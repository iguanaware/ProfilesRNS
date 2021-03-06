SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Profile.Data].[Publication.GetGroupMemberPublications]
	@GroupID INT=NULL,
	@StartDate DateTime='01/01/1753',
	@EndDate DateTime='01/01/2500',
	@PersonIDs XML=NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	CREATE TABLE #pubs (
		PMID int null,
		MPID nvarchar(50) null
	)

	IF @PersonIDs is null
	BEGIN
		insert into #pubs
		  select distinct pmid, mpid from [Profile.Data].[Publication.Person.Include] a
			  join [Profile.Data].Person p on a.PersonID = p.PersonID
			  join [Profile.Data].[Group.Member] g on p.UserID = g.UserID
			  and g.GroupID = @GroupID
			  where (pmid is null or pmid not in (select pmid from [Profile.Data].[Publication.Group.Include] where GroupID = @GroupID and PMID is not null))
			  and (mpid is null or mpid not in (select copiedMPID from [Profile.Data].[Publication.Group.MyPub.General] where GroupID = @GroupID and copiedMPID is not null))
	END 
	ELSE
	BEGIN
		;with People as (
			select nref.value('.','varchar(max)') as PersonID from @PersonIDs.nodes('//PersonIDs/PersonID') as R(nref)
		)
		insert into #pubs
			select distinct pmid, mpid from [Profile.Data].[Publication.Person.Include] a
				join People p on a.PersonID = p.PersonID
				where (pmid is null or pmid not in (select pmid from [Profile.Data].[Publication.Group.Include] where GroupID = @GroupID and PMID is not null))
				and (mpid is null or mpid not in (select copiedMPID from [Profile.Data].[Publication.Group.MyPub.General] where GroupID = @GroupID and copiedMPID is not null))
	END

  select top 100 '' as rownum, reference, case when e.PMID is not null then 'true' else 'false' end as FromPubMed, 0 as PubID, e.pmid, e.mpid, e.url, e.EntityDate as pubdate, '' as category from [Profile.Data].[vwPublication.Entity.InformationResource] e
	  join #pubs a on (a.PMID = e.PMID and e.MPID is null) OR (a.MPID = e.MPID and e.PMID is null)
	  where @StartDate <= isnull(EntityDate,'01/01/1900') and @EndDate >= isnull(EntityDate,'01/01/1900')
	  order by EntityDate desc
END

GO
