SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Profile.Data].[Group.Manager.AddManager]
	-- Group
	@GroupID INT=NULL, 
	@GroupNodeID BIGINT=NULL,
	@GroupURI VARCHAR(400)=NULL,
	-- User
	@UserID INT=NULL,
	@UserNodeID BIGINT=NULL,
	@UserURI VARCHAR(400)=NULL,
	-- Other
	@SessionID UNIQUEIDENTIFIER=NULL, 
	@Error BIT=NULL OUTPUT 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	/*
	
	This stored procedure adds a Group Manager.
	Specify:
	1) A Group by either GroupID, NodeID or URI.
	2) A User by UserID, NodeID, or URI.
	
	*/
	
	SELECT @Error = 0

	-------------------------------------------------
	-- Validate and prepare variables
	-------------------------------------------------
	
	-- Convert URIs and NodeIDs to GroupID
 	IF (@GroupNodeID IS NULL) AND (@GroupURI IS NOT NULL)
		SELECT @GroupNodeID = [RDF.].fnURI2NodeID(@GroupURI)
 	IF (@GroupID IS NULL) AND (@GroupNodeID IS NOT NULL)
		SELECT @GroupID = CAST(m.InternalID AS INT)
			FROM [RDF.Stage].[InternalNodeMap] m, [RDF.].Node n
			WHERE m.Status = 3 AND m.ValueHash = n.ValueHash AND n.NodeID = @GroupNodeID
	IF @GroupNodeID IS NULL
		SELECT @GroupNodeID = NodeID
			FROM [RDF.Stage].InternalNodeMap
			WHERE Class = 'http://xmlns.com/foaf/0.1/Group' AND InternalType = 'Group' AND InternalID = @GroupID

	-- Convert URIs and NodeIDs to UserID
 	IF (@UserNodeID IS NULL) AND (@UserURI IS NOT NULL)
		SELECT @UserNodeID = [RDF.].fnURI2NodeID(@UserURI)
 	IF (@UserID IS NULL) AND (@UserNodeID IS NOT NULL)
		SELECT @UserID = CAST(m.InternalID AS INT)
			FROM [RDF.Stage].[InternalNodeMap] m, [RDF.].Node n
			WHERE m.Status = 3 AND m.ValueHash = n.ValueHash AND n.NodeID = @UserNodeID
	IF @UserNodeID IS NULL
		SELECT @UserNodeID = NodeID
			FROM [RDF.Stage].InternalNodeMap
			WHERE Class = 'http://profiles.catalyst.harvard.edu/ontology/prns#User' AND InternalType = 'User' AND InternalID = @UserID

	-- Check that both a Group and a User exist
	IF (@GroupID IS NULL) OR (@UserID IS NULL) OR (@GroupNodeID IS NULL) OR (@UserNodeID IS NULL)
		RETURN;

	-------------------------------------------------
	-- Add the manager
	-------------------------------------------------

	INSERT INTO [Profile.Data].[Group.Manager] (GroupID, UserID)
		SELECT @GroupID, @UserID
		WHERE NOT EXISTS (SELECT * FROM [Profile.Data].[Group.Manager] WHERE GroupID=@GroupID AND UserID=@UserID)

	EXEC [RDF.].GetStoreTriple	@SubjectID = @GroupNodeID,
								@PredicateURI = 'http://profiles.catalyst.harvard.edu/ontology/prns#hasGroupManager',
								@ObjectID = @UserNodeID,
								@ViewSecurityGroup = -1,
								@Weight = 1,
								@SessionID = @SessionID,
								@Error = @Error OUTPUT

	EXEC [Profile.Data].[Group.UpdateSecurityMembership]

END




GO
