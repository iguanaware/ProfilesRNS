SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Profile.Data].[Publication.Entity.UpdateEntityOneGroup]
	@GroupID INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

 
	-- *******************************************************************
	-- *******************************************************************
	-- Update InformationResource entities
	-- *******************************************************************
	-- *******************************************************************
 
 
	----------------------------------------------------------------------
	-- Get a list of current publications
	----------------------------------------------------------------------
 
	CREATE TABLE #Publications
	(
		PMID INT NULL ,
		MPID NVARCHAR(50) NULL ,
		PMCID NVARCHAR(55) NULL,
		EntityDate DATETIME NULL ,
		Reference VARCHAR(MAX) NULL ,
		Source VARCHAR(25) NULL ,
		URL VARCHAR(1000) NULL ,
		Title VARCHAR(4000) NULL
	)
 
	-- Add PMIDs to the publications temp table
	INSERT  INTO #Publications
            ( PMID ,
			  PMCID,
              EntityDate ,
              Reference ,
              Source ,
              URL ,
              Title
            )
            SELECT -- Get Pub Med pubs
                    PG.PMID ,
					PG.PMCID,
                    EntityDate = PG.PubDate,
                    Reference = REPLACE([Profile.Cache].[fnPublication.Pubmed.General2Reference](PG.PMID,
                                                              PG.ArticleDay,
                                                              PG.ArticleMonth,
                                                              PG.ArticleYear,
                                                              PG.ArticleTitle,
                                                              PG.Authors,
                                                              PG.AuthorListCompleteYN,
                                                              PG.Issue,
                                                              PG.JournalDay,
                                                              PG.JournalMonth,
                                                              PG.JournalYear,
                                                              PG.MedlineDate,
                                                              PG.MedlinePgn,
                                                              PG.MedlineTA,
                                                              PG.Volume, 0),
                                        CHAR(11), '') ,
                    Source = 'PubMed',
                    URL = 'http://www.ncbi.nlm.nih.gov/pubmed/' + CAST(ISNULL(PG.pmid, '') AS VARCHAR(20)),
                    Title = left((case when IsNull(PG.ArticleTitle,'') <> '' then PG.ArticleTitle else 'Untitled Publication' end),4000)
            FROM    [Profile.Data].[Publication.PubMed.General] PG
			WHERE	PG.PMID IN (
						SELECT PMID 
						FROM [Profile.Data].[Publication.Group.Include]
						WHERE PMID IS NOT NULL AND GroupID = @GroupID
					)
					AND PG.PMID NOT IN (
						SELECT PMID
						FROM [Profile.Data].[Publication.Entity.InformationResource]
						WHERE PMID IS NOT NULL
					)
 
	-- Add MPIDs to the publications temp table
	INSERT  INTO #Publications
            ( MPID ,
              EntityDate ,
			  Reference ,
			  Source ,
              URL ,
              Title
            )
            SELECT  MPID ,
                    EntityDate ,
 
 
                     Reference = REPLACE(authors
										+ (CASE WHEN IsNull(article,'') <> '' THEN article + '. ' ELSE '' END)
										+ (CASE WHEN IsNull(pub,'') <> '' THEN pub + '. ' ELSE '' END)
										+ y
                                        + CASE WHEN y <> ''
                                                    AND vip <> '' THEN '; '
                                               ELSE ''
                                          END + vip
                                        + CASE WHEN y <> ''
                                                    OR vip <> '' THEN '.'
                                               ELSE ''
                                          END, CHAR(11), '') ,
                    Source = 'Custom' ,
                    URL = url,
                    Title = left((case when IsNull(article,'')<>'' then article when IsNull(pub,'')<>'' then pub else 'Untitled Publication' end),4000)
            FROM    ( SELECT    MPID ,
                                EntityDate ,
                                url ,
                                authors = CASE WHEN authors = '' THEN ''
                                               WHEN RIGHT(authors, 1) = '.'
                                               THEN LEFT(authors,
                                                         LEN(authors) - 1)
                                               ELSE authors
                                          END ,
                                article = CASE WHEN article = '' THEN ''
                                               WHEN RIGHT(article, 1) = '.'
                                               THEN LEFT(article,
                                                         LEN(article) - 1)
                                               ELSE article
                                          END ,
                                pub = CASE WHEN pub = '' THEN ''
                                           WHEN RIGHT(pub, 1) = '.'
                                           THEN LEFT(pub, LEN(pub) - 1)
                                           ELSE pub
                                      END ,
                                y ,
                                vip
                      FROM      ( SELECT    MPG.mpid ,
                                            EntityDate = MPG.publicationdt ,
                                            authors = CASE WHEN RTRIM(LTRIM(COALESCE(MPG.authors,
                                                              ''))) = ''
                                                           THEN ''
                                                           WHEN RIGHT(COALESCE(MPG.authors,
                                                              ''), 1) = '.'
                                                            THEN  COALESCE(MPG.authors,
                                                              '') + ' '
                                                           ELSE COALESCE(MPG.authors,
                                                              '') + '. '
                                                      END ,
                                            url = CASE WHEN COALESCE(MPG.url,
                                                              '') <> ''
                                                            AND LEFT(COALESCE(MPG.url,
                                                              ''), 4) = 'http'
                                                       THEN MPG.url
                                                       WHEN COALESCE(MPG.url,
                                                              '') <> ''
                                                       THEN 'http://' + MPG.url
                                                       ELSE ''
                                                  END ,
                                            article = LTRIM(RTRIM(COALESCE(MPG.articletitle,
                                                              ''))) ,
                                            pub = LTRIM(RTRIM(COALESCE(MPG.pubtitle,
                                                              ''))) ,
                                            y = CASE WHEN MPG.publicationdt > '1/1/1901'
                                                     THEN CONVERT(VARCHAR(50), YEAR(MPG.publicationdt))
                                                     ELSE ''
                                                END ,
                                            vip = COALESCE(MPG.volnum, '')
                                            + CASE WHEN COALESCE(MPG.issuepub,
                                                              '') <> ''
                                                   THEN '(' + MPG.issuepub
                                                        + ')'
                                                   ELSE ''
                                              END
                                            + CASE WHEN ( COALESCE(MPG.paginationpub,
                                                              '') <> '' )
                                                        AND ( COALESCE(MPG.volnum,
                                                              '')
                                                              + COALESCE(MPG.issuepub,
                                                              '') <> '' )
                                                   THEN ':'
                                                   ELSE ''
                                              END + COALESCE(MPG.paginationpub,
                                                             '')
                                  FROM      [Profile.Data].[Publication.Group.MyPub.General] MPG
                                  INNER JOIN [Profile.Data].[Publication.Group.Include] PL ON MPG.mpid = PL.mpid
                                                           AND PL.mpid NOT LIKE 'DASH%'
                                                           AND PL.mpid NOT LIKE 'ISI%'
                                                           AND PL.pmid IS NULL
                                                           AND PL.GroupID = @GroupID
									WHERE MPG.MPID NOT IN (
										SELECT MPID
										FROM [Profile.Data].[Publication.Entity.InformationResource]
										WHERE (MPID IS NOT NULL)
									)
                                ) T0
                    ) T0
 
	CREATE NONCLUSTERED INDEX idx_pmid on #publications(pmid)
	CREATE NONCLUSTERED INDEX idx_mpid on #publications(mpid)

	----------------------------------------------------------------------
	-- Update the Publication.Entity.InformationResource table
	----------------------------------------------------------------------
 
	DECLARE @maxEntityId AS INT
	SELECT @maxEntityId = MAX(EntityID) FROM [Profile.Data].[Publication.Entity.InformationResource]

	-- Insert new publications
	INSERT INTO [Profile.Data].[Publication.Entity.InformationResource] (
			PMID,
			PMCID,
			MPID,
			EntityName,
			EntityDate,
			Reference,
			Source,
			URL,
			IsActive
		)
		SELECT 	PMID,
				PMCID,
				MPID,
				Title,
				EntityDate,
				Reference,
				Source,
				URL,
				1 IsActive
		FROM #publications
	-- Assign an EntityName, PubYear, and YearWeight
	UPDATE e
		SET --e.EntityName = 'Publication ' + CAST(e.EntityID as VARCHAR(50)),
			e.PubYear = year(e.EntityDate),
			e.YearWeight = (case when e.EntityDate is null then 0.5
							when year(e.EntityDate) <= 1901 then 0.5
							else power(cast(0.5 as float),cast(datediff(d,e.EntityDate,GetDate()) as float)/365.25/10)
							end)
		FROM [Profile.Data].[Publication.Entity.InformationResource] e,
			#publications p
		WHERE ((e.PMID = p.PMID) OR (e.MPID = p.MPID))
 

	-- *******************************************************************
	-- *******************************************************************
	-- Update RDF
	-- *******************************************************************
	-- *******************************************************************



	--------------------------------------------------------------
	-- Version 3 : Create stub RDF
	--------------------------------------------------------------


	CREATE TABLE #sql (
		i INT IDENTITY(0,1) PRIMARY KEY,
		s NVARCHAR(MAX)
	)
	INSERT INTO #sql (s)
		SELECT	'EXEC [RDF.Stage].ProcessDataMap '
					+'  @DataMapID = '+CAST(DataMapID AS VARCHAR(50))
					+', @InternalIdIn = '+InternalIdIn
					+', @TurnOffIndexing=0, @SaveLog=0; '
		FROM (
		  	SELECT *, '''SELECT CAST (EntityID AS VARCHAR(50)) FROM [Profile.Data].[Publication.Entity.InformationResource] WHERE EntityID > ' + CAST(@maxEntityId AS VARCHAR(50)) + '''' InternalIdIn
				FROM [Ontology.].DataMap
				WHERE class = 'http://vivoweb.org/ontology/core#InformationResource' 
					AND property IS NULL
					AND NetworkProperty IS NULL
			UNION ALL
			SELECT *, '''' + CAST(@GroupID AS VARCHAR(50)) + '''' InternalIdIn
				FROM [Ontology.].DataMap
				WHERE class = 'http://xmlns.com/foaf/0.1/Group'
					AND property = 'http://profiles.catalyst.harvard.edu/ontology/prns#associatedInformationResource'
					AND NetworkProperty IS NULL
		) t
		ORDER BY DataMapID

	DECLARE @s NVARCHAR(MAX)
	WHILE EXISTS (SELECT * FROM #sql)
	BEGIN
		SELECT @s = s
			FROM #sql
			WHERE i = (SELECT MIN(i) FROM #sql)
		print @s
		EXEC sp_executesql @s
		DELETE
			FROM #sql
			WHERE i = (SELECT MIN(i) FROM #sql)
	END

	--select * from [Ontology.].DataMap


/*

	--------------------------------------------------------------
	-- Version 1 : Create all RDF using ProcessDataMap
	--------------------------------------------------------------

	CREATE TABLE #sql (
		i INT IDENTITY(0,1) PRIMARY KEY,
		s NVARCHAR(MAX)
	)
	INSERT INTO #sql (s)
		SELECT	'EXEC [RDF.Stage].ProcessDataMap '
					+'  @DataMapID = '+CAST(DataMapID AS VARCHAR(50))
					+', @InternalIdIn = '+InternalIdIn
					+', @TurnOffIndexing=0, @SaveLog=0; '
		FROM (
			SELECT *, '''SELECT CAST(InformationResourceID AS VARCHAR(50)) FROM [Profile.Data].[Publication.Entity.Authorship] WHERE PersonID = '+CAST(@PersonID AS VARCHAR(50))+'''' InternalIdIn
				FROM [Ontology.].DataMap
				WHERE class = 'http://vivoweb.org/ontology/core#InformationResource' 
					AND IsNull(property,'') <> 'http://vivoweb.org/ontology/core#informationResourceInAuthorship'
					AND NetworkProperty IS NULL
			UNION ALL
			SELECT *, '''SELECT CAST(EntityID AS VARCHAR(50)) FROM [Profile.Data].[Publication.Entity.Authorship] WHERE PersonID = '+CAST(@PersonID AS VARCHAR(50))+'''' InternalIdIn
				FROM [Ontology.].DataMap
				WHERE class = 'http://vivoweb.org/ontology/core#Authorship'
					AND IsNull(property,'') NOT IN ('http://vivoweb.org/ontology/core#linkedAuthor','http://vivoweb.org/ontology/core#linkedInformationResource')
					AND NetworkProperty IS NULL
			UNION ALL
			SELECT *, '''SELECT CAST(InformationResourceID AS VARCHAR(50)) FROM [Profile.Data].[Publication.Entity.Authorship] WHERE PersonID = '+CAST(@PersonID AS VARCHAR(50))+'''' InternalIdIn
				FROM [Ontology.].DataMap
				WHERE class = 'http://vivoweb.org/ontology/core#InformationResource' 
					AND property = 'http://vivoweb.org/ontology/core#informationResourceInAuthorship'
					AND NetworkProperty IS NULL
			UNION ALL
			SELECT *, '''' + CAST(@PersonID AS VARCHAR(50)) + '''' InternalIdIn
				FROM [Ontology.].DataMap
				WHERE class = 'http://xmlns.com/foaf/0.1/Person' 
					AND property = 'http://vivoweb.org/ontology/core#authorInAuthorship'
					AND NetworkProperty IS NULL
		) t
		ORDER BY DataMapID

	DECLARE @s NVARCHAR(MAX)
	WHILE EXISTS (SELECT * FROM #sql)
	BEGIN
		SELECT @s = s
			FROM #sql
			WHERE i = (SELECT MIN(i) FROM #sql)
		--print @s
		EXEC sp_executesql @s
		DELETE
			FROM #sql
			WHERE i = (SELECT MIN(i) FROM #sql)
	END

*/


/*

	---------------------------------------------------------------------------------
	-- Version 2 : Create new entities using ProcessDataMap, and triples manually
	---------------------------------------------------------------------------------

	CREATE TABLE #sql (
		i INT IDENTITY(0,1) PRIMARY KEY,
		s NVARCHAR(MAX)
	)
	INSERT INTO #sql (s)
		SELECT	'EXEC [RDF.Stage].ProcessDataMap '
					+'  @DataMapID = '+CAST(DataMapID AS VARCHAR(50))
					+', @InternalIdIn = '+InternalIdIn
					+', @TurnOffIndexing=0, @SaveLog=0; '
		FROM (
			SELECT *, '''SELECT CAST(InformationResourceID AS VARCHAR(50)) FROM [Profile.Data].[Publication.Entity.Authorship] WHERE PersonID = '+CAST(@PersonID AS VARCHAR(50))+'''' InternalIdIn
				FROM [Ontology.].DataMap
				WHERE class = 'http://vivoweb.org/ontology/core#InformationResource' 
					AND IsNull(property,'') <> 'http://vivoweb.org/ontology/core#informationResourceInAuthorship'
					AND NetworkProperty IS NULL
			UNION ALL
			SELECT *, '''SELECT CAST(EntityID AS VARCHAR(50)) FROM [Profile.Data].[Publication.Entity.Authorship] WHERE PersonID = '+CAST(@PersonID AS VARCHAR(50))+'''' InternalIdIn
				FROM [Ontology.].DataMap
				WHERE class = 'http://vivoweb.org/ontology/core#Authorship'
					AND IsNull(property,'') NOT IN ('http://vivoweb.org/ontology/core#linkedAuthor','http://vivoweb.org/ontology/core#linkedInformationResource')
					AND NetworkProperty IS NULL
		) t
		ORDER BY DataMapID

	--select * from #sql
	--return

	DECLARE @s NVARCHAR(MAX)
	WHILE EXISTS (SELECT * FROM #sql)
	BEGIN
		SELECT @s = s
			FROM #sql
			WHERE i = (SELECT MIN(i) FROM #sql)
		--print @s
		EXEC sp_executesql @s
		DELETE
			FROM #sql
			WHERE i = (SELECT MIN(i) FROM #sql)
	END


	CREATE TABLE #a (
		PersonID INT,
		AuthorshipID INT,
		InformationResourceID INT,
		IsActive BIT,
		PersonNodeID BIGINT,
		AuthorshipNodeID BIGINT,
		InformationResourceNodeID BIGINT,
		AuthorInAuthorshipTripleID BIGINT,
		LinkedAuthorTripleID BIGINT,
		LinkedInformationResourceTripleID BIGINT,
		InformationResourceInAuthorshipTripleID BIGINT,
		AuthorRank INT,
		EntityDate DATETIME,
		TripleWeight FLOAT,
		AuthorRecord INT
	)
	-- Get authorship records
	INSERT INTO #a (PersonID, AuthorshipID, InformationResourceID, IsActive, AuthorRank, EntityDate, TripleWeight, AuthorRecord)
		SELECT PersonID, EntityID, InformationResourceID, IsActive, 
				AuthorRank, EntityDate, IsNull(authorweight * yearweight,0),
				0
			FROM [Profile.Data].[Publication.Entity.Authorship]
			WHERE PersonID = @PersonID
		UNION ALL
		SELECT PersonID, EntityID, InformationResourceID, IsActive, 
				AuthorRank, EntityDate, IsNull(authorweight * yearweight,0),
				1
			FROM [Profile.Data].[Publication.Entity.Authorship]
			WHERE PersonID <> @PersonID 
				AND IsActive = 1
				AND InformationResourceID IN (
					SELECT InformationResourceID
					FROM [Profile.Data].[Publication.Entity.Authorship]
					WHERE PersonID = @PersonID
				)
	-- Get entity IDs
	UPDATE a
		SET a.PersonNodeID = m.NodeID
		FROM #a a, [RDF.Stage].InternalNodeMap m
		WHERE m.Class = 'http://xmlns.com/foaf/0.1/Person'
			AND m.InternalType = 'Person'
			AND m.InternalID = CAST(a.PersonID AS VARCHAR(50))
	UPDATE a
		SET a.AuthorshipNodeID = m.NodeID
		FROM #a a, [RDF.Stage].InternalNodeMap m
		WHERE m.Class = 'http://vivoweb.org/ontology/core#Authorship'
			AND m.InternalType = 'Authorship'
			AND m.InternalID = CAST(a.AuthorshipID AS VARCHAR(50))
	UPDATE a
		SET a.InformationResourceNodeID = m.NodeID
		FROM #a a, [RDF.Stage].InternalNodeMap m
		WHERE m.Class = 'http://vivoweb.org/ontology/core#InformationResource'
			AND m.InternalType = 'InformationResource'
			AND m.InternalID = CAST(a.InformationResourceID AS VARCHAR(50))
	-- Get triple IDs
	UPDATE a
		SET a.AuthorInAuthorshipTripleID = t.TripleID
		FROM #a a, [RDF.].Triple t
		WHERE a.PersonNodeID IS NOT NULL AND a.AuthorshipNodeID IS NOT NULL
			AND t.subject = a.PersonNodeID
			AND t.predicate = [RDF.].fnURI2NodeID('http://vivoweb.org/ontology/core#authorInAuthorship')
			AND t.object = a.AuthorshipNodeID
	UPDATE a
		SET a.LinkedAuthorTripleID = t.TripleID
		FROM #a a, [RDF.].Triple t
		WHERE a.PersonNodeID IS NOT NULL AND a.AuthorshipNodeID IS NOT NULL
			AND t.subject = a.AuthorshipNodeID
			AND t.predicate = [RDF.].fnURI2NodeID('http://vivoweb.org/ontology/core#linkedAuthor')
			AND t.object = a.PersonNodeID
	UPDATE a
		SET a.LinkedInformationResourceTripleID = t.TripleID
		FROM #a a, [RDF.].Triple t
		WHERE a.AuthorshipNodeID IS NOT NULL AND a.InformationResourceID IS NOT NULL
			AND t.subject = a.AuthorshipNodeID
			AND t.predicate = [RDF.].fnURI2NodeID('http://vivoweb.org/ontology/core#linkedInformationResource')
			AND t.object = a.InformationResourceNodeID
	UPDATE a
		SET a.InformationResourceInAuthorshipTripleID = t.TripleID
		FROM #a a, [RDF.].Triple t
		WHERE a.AuthorshipNodeID IS NOT NULL AND a.InformationResourceID IS NOT NULL
			AND t.subject = a.InformationResourceNodeID
			AND t.predicate = [RDF.].fnURI2NodeID('http://vivoweb.org/ontology/core#informationResourceInAuthorship')
			AND t.object = a.AuthorshipNodeID
	
	--select * from #a
	--return
	--select * from [ontology.].datamap



	SELECT a.IsActive, a.subject, m._PropertyNode predicate, a.object, 
			a.TripleWeight, 0 ObjectType, a.SortOrder,
			IsNull(s.ViewSecurityGroup, m.ViewSecurityGroup) ViewSecurityGroup,
			a.TripleID, t.SortOrder ExistingSortOrder, X
		INTO #b
		FROM (
				SELECT AuthorshipNodeID subject, InformationResourceNodeID object, TripleWeight, 
						'http://vivoweb.org/ontology/core#Authorship' Class,
						'http://vivoweb.org/ontology/core#linkedInformationResource' Property,
						1 SortOrder,
						IsActive,
						LinkedInformationResourceTripleID TripleID,
						1 X
					FROM #a
					WHERE AuthorRecord = 0
					--WHERE IsActive = 1
				UNION ALL
				SELECT AuthorshipNodeID subject, PersonNodeID object, 1 TripleWeight,
						'http://vivoweb.org/ontology/core#Authorship' Class,
						'http://vivoweb.org/ontology/core#linkedAuthor' Property,
						1 SortOrder,
						IsActive,
						LinkedAuthorTripleID TripleID,
						2 X
					FROM #a
					WHERE AuthorRecord = 0
					--WHERE IsActive = 1
				UNION ALL
				SELECT InformationResourceNodeID subject, AuthorshipNodeID object, TripleWeight, 
						'http://vivoweb.org/ontology/core#InformationResource' Class,
						'http://vivoweb.org/ontology/core#informationResourceInAuthorship' Property,
						row_number() over (partition by InformationResourceNodeID, IsActive order by AuthorRank, t.SortOrder, AuthorshipNodeID) SortOrder,
						IsActive,
						InformationResourceInAuthorshipTripleID TripleID,
						3 X
					FROM #a a
						LEFT OUTER JOIN [RDF.].[Triple] t
						ON a.InformationResourceInAuthorshipTripleID = t.TripleID
					--WHERE IsActive = 1
				UNION ALL
				SELECT PersonNodeID subject, AuthorshipNodeID object, 1 TripleWeight, 
						'http://xmlns.com/foaf/0.1/Person' Class,
						'http://vivoweb.org/ontology/core#authorInAuthorship' Property,
						row_number() over (partition by PersonNodeID, IsActive order by EntityDate desc) SortOrder,
						IsActive,
						AuthorInAuthorshipTripleID TripleID,
						4 X
					FROM #a
					WHERE AuthorRecord = 0
					--WHERE IsActive = 1
			) a
			INNER JOIN [Ontology.].[DataMap] m
				ON m.Class = a.Class AND m.NetworkProperty IS NULL AND m.Property = a.Property
			LEFT OUTER JOIN [RDF.].[Triple] t
				ON a.TripleID = t.TripleID
			LEFT OUTER JOIN [RDF.Security].[NodeProperty] s
				ON s.NodeID = a.subject
					AND s.Property = m._PropertyNode

	--SELECT * FROM #b ORDER BY X, subject, property, IsActive, sortorder

	-- Delete
	DELETE
		FROM [RDF.].Triple
		WHERE TripleID IN (
			SELECT TripleID
			FROM #b
			WHERE IsActive = 0 AND TripleID IS NOT NULL
		)
	--select @@ROWCOUNT

	-- Update
	UPDATE t
		SET t.SortOrder = b.SortOrder
		FROM [RDF.].Triple t
			INNER JOIN #b b
			ON t.TripleID = b.TripleID
				AND b.IsActive = 1 
				AND b.TripleID IS NOT NULL
				AND b.SortOrder <> b.ExistingSortOrder
	--select @@ROWCOUNT

	-- Insert
	INSERT INTO [RDF.].Triple (Subject,Predicate,Object,TripleHash,Weight,Reitification,ObjectType,SortOrder,ViewSecurityGroup,Graph)
		SELECT Subject,Predicate,Object,
				[RDF.].fnTripleHash(Subject,Predicate,Object),
				TripleWeight,NULL,0,SortOrder,ViewSecurityGroup,1
			FROM #b
			WHERE IsActive = 1 AND TripleID IS NULL
	--select @@ROWCOUNT

*/


END

GO
