SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Edit.Module].[CustomEditAssociatedInformationResource.GetList]
	@NodeID bigint = NULL,
	@SessionID uniqueidentifier = NULL
AS
BEGIN

	DECLARE @GroupID INT
 
	SELECT @GroupID = CAST(m.InternalID AS INT)
		FROM [RDF.Stage].[InternalNodeMap] m, [RDF.].Node n
		WHERE m.Status = 3 AND m.ValueHash = n.ValueHash AND n.NodeID = @NodeID
 
	SELECT r.Reference, (CASE WHEN r.PMID IS NOT NULL THEN 1 ELSE 0 END) FromPubMed, i.PubID, r.PMID, r.MPID, NULL Category, r.URL, r.EntityDate PubDate, r.EntityID, r.Source, r.IsActive, i.GroupID
		FROM [Profile.Data].[Publication.Group.Include] i
			INNER JOIN [Profile.Data].[Publication.Entity.InformationResource] r
				ON i.PMID = r.PMID AND i.PMID IS NOT NULL
				AND i.GroupID = @GroupID
	UNION ALL
	SELECT r.Reference, (CASE WHEN r.PMID IS NOT NULL THEN 1 ELSE 0 END) FromPubMed, i.PubID, r.PMID, r.MPID, g.HmsPubCategory Category, r.URL, r.EntityDate PubDate, r.EntityID, r.Source, r.IsActive, i.GroupID
		FROM [Profile.Data].[Publication.Group.Include] i
			INNER JOIN [Profile.Data].[Publication.Entity.InformationResource] r
				ON i.MPID = r.MPID AND i.PMID IS NULL AND i.MPID IS NOT NULL
				AND i.GroupID = @GroupID
			INNER JOIN [Profile.Data].[Publication.Group.MyPub.General] g
				ON i.MPID = g.MPID
	ORDER BY EntityDate DESC, EntityID

END

GO
