SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Profile.Data].[Group.Member.DeleteMember]
	-- Role
	@MemberRoleID VARCHAR(50)=NULL,
	@MemberRoleNodeID BIGINT=NULL,
	@MemberRoleURI VARCHAR(400)=NULL,
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
	@Error BIT=NULL OUTPUT, 
	@NodeID BIGINT=NULL OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	/*
	
	This stored procedure deletes a Group Member.
	Either specify:
	1) A MemberRole by either MemberRoleID, NodeID, or URI.
	2) A Group by either GroupID, NodeID or URI;
		and, a User by UserID, NodeID, or URI.
	
	*/
	
	SELECT @Error = 0

	-------------------------------------------------
	-- Validate and prepare variables
	-------------------------------------------------
	
	-- Convert IDs and URIs to MemberRoleID

 	IF (@MemberRoleNodeID IS NULL) AND (@MemberRoleURI IS NOT NULL)
		SELECT @MemberRoleNodeID = [RDF.].fnURI2NodeID(@MemberRoleURI)
 	IF (@MemberRoleID IS NULL) AND (@MemberRoleNodeID IS NOT NULL)
		SELECT @MemberRoleID = CAST(m.InternalID AS INT)
			FROM [RDF.Stage].[InternalNodeMap] m, [RDF.].Node n
			WHERE m.Status = 3 AND m.ValueHash = n.ValueHash AND n.NodeID = @MemberRoleNodeID

	IF (@MemberRoleID IS NULL)
	BEGIN
		-- Convert URIs and NodeIDs to GroupID
 		IF (@GroupNodeID IS NULL) AND (@GroupURI IS NOT NULL)
			SELECT @GroupNodeID = [RDF.].fnURI2NodeID(@GroupURI)
 		IF (@GroupID IS NULL) AND (@GroupNodeID IS NOT NULL)
			SELECT @GroupID = CAST(m.InternalID AS INT)
				FROM [RDF.Stage].[InternalNodeMap] m, [RDF.].Node n
				WHERE m.Status = 3 AND m.ValueHash = n.ValueHash AND n.NodeID = @GroupNodeID

		-- Convert URIs and NodeIDs to UserID
 		IF (@UserNodeID IS NULL) AND (@UserURI IS NOT NULL)
			SELECT @UserNodeID = [RDF.].fnURI2NodeID(@UserURI)
 		IF (@UserID IS NULL) AND (@UserNodeID IS NOT NULL)
			SELECT @UserID = CAST(m.InternalID AS INT)
				FROM [RDF.Stage].[InternalNodeMap] m, [RDF.].Node n
				WHERE m.Status = 3 AND m.ValueHash = n.ValueHash AND n.NodeID = @UserNodeID

		-- Lookup the MemberRoleID
		IF (@GroupID IS NOT NULL) AND (@UserID IS NOT NULL)
			SELECT @MemberRoleID = MemberRoleID
			FROM [Profile.Data].[Group.Member]
			WHERE GroupID = @GroupID AND UserID = @UserID
	END

	IF (@MemberRoleID IS NULL)
		RETURN;

	-------------------------------------------------
	-- Delete the MemberRole
	-------------------------------------------------

	SELECT @MemberRoleNodeID = NodeID
		FROM [RDF.Stage].InternalNodeMap
		WHERE Class = 'http://vivoweb.org/ontology/core#MemberRole' AND InternalType = 'MemberRole' AND InternalID = @MemberRoleID

	UPDATE [Profile.Data].[Group.Member]
		SET IsActive = 0
		WHERE MemberRoleID = @MemberRoleID

	IF (@MemberRoleNodeID IS NOT NULL)
		UPDATE [RDF.].[Node]
			SET ViewSecurityGroup = 0
			WHERE NodeID = @MemberRoleNodeID

	SELECT @NodeID = @MemberRoleNodeID

END



GO
