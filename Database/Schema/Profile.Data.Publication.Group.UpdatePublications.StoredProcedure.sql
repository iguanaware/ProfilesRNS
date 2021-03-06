SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [Profile.Data].[Publication.Group.UpdatePublications]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrMsg nvarchar(4000), @ErrSeverity int,@proc VARCHAR(200),@date DATETIME,@auditid UNIQUEIDENTIFIER 
	SELECT @proc = OBJECT_NAME(@@PROCID),@date=GETDATE() 	
	 
	BEGIN TRY
	BEGIN TRANSACTION

		DELETE FROM [Profile.Data].[Publication.Group.MyPub.General] 
			WHERE GroupID in (SELECT GroupID FROM [Profile.Data].[Publication.Group.Option] WHERE [IncludeMemberPublications] = 1)

		INSERT INTO [Profile.Data].[Publication.Group.MyPub.General](
			[MPID]
			,[GroupID]
			,[PMID]
			,[HmsPubCategory]
			,[NlmPubCategory]
			,[PubTitle]
			,[ArticleTitle]
			,[ArticleType]
			,[ConfEditors]
			,[ConfLoc]
			,[EDITION]
			,[PlaceOfPub]
			,[VolNum]
			,[PartVolPub]
			,[IssuePub]
			,[PaginationPub]
			,[AdditionalInfo]
			,[Publisher]
			,[SecondaryAuthors]
			,[ConfNm]
			,[ConfDTs]
			,[ReptNumber]
			,[ContractNum]
			,[DissUnivNm]
			,[NewspaperCol]
			,[NewspaperSect]
			,[PublicationDT]
			,[Abstract]
			,[Authors]
			,[URL]
			,[CreatedDT]
			,[CreatedBy]
			,[UpdatedDT]
			,[UpdatedBy]
			,[CopiedMPID])
		SELECT
			CAST(NewID() as nvarchar(50)) as [MPID]
			,gm.[GroupID]
			,[PMID]
			,[HmsPubCategory]
			,[NlmPubCategory]
			,[PubTitle]
			,[ArticleTitle]
			,[ArticleType]
			,[ConfEditors]
			,[ConfLoc]
			,[EDITION]
			,[PlaceOfPub]
			,[VolNum]
			,[PartVolPub]
			,[IssuePub]
			,[PaginationPub]
			,[AdditionalInfo]
			,[Publisher]
			,[SecondaryAuthors]
			,[ConfNm]
			,[ConfDTs]
			,[ReptNumber]
			,[ContractNum]
			,[DissUnivNm]
			,[NewspaperCol]
			,[NewspaperSect]
			,[PublicationDT]
			,[Abstract]
			,[Authors]
			,[URL]
			,[CreatedDT]
			,[CreatedBy]
			,[UpdatedDT]
			,[UpdatedBy]
			,MPID as [CopiedMPID] 
			FROM [Profile.Data].[Publication.MyPub.General] mpg
				JOIN [Profile.Data].Person p
				ON mpg.PersonID = p.PersonID
				JOIN [Profile.Data].[Group.Member] gm
				ON p.UserID = gm.UserID
				JOIN [Profile.Data].[Publication.Group.Option] o
				ON o.GroupID = gm.GroupID
				AND o.IncludeMemberPublications = 1

		DELETE FROM [Profile.Data].[Publication.Group.Include]
			WHERE GroupID in (SELECT GroupID FROM [Profile.Data].[Publication.Group.Option] WHERE [IncludeMemberPublications] = 1)

		INSERT INTO [Profile.Data].[Publication.Group.Include]
		SELECT CAST(NewID() as nvarchar(50)), * FROM 
		(
			SELECT DISTINCT gm.GroupID, PMID, MPID FROM [Profile.Data].[Publication.Person.Include] mpg
				JOIN [Profile.Data].Person p
				ON mpg.PersonID = p.PersonID
				JOIN [Profile.Data].[Group.Member] gm
				ON p.UserID = gm.UserID
				JOIN [Profile.Data].[Publication.Group.Option] o
				ON o.GroupID = gm.GroupID
				AND o.IncludeMemberPublications = 1 
		) t



	COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
		--Check success
		IF @@TRANCOUNT > 0  ROLLBACK
		SELECT @date=GETDATE()
		EXEC [Profile.Cache].[Process.AddAuditUpdate] @auditid=@auditid OUTPUT,@ProcessName =@proc,@ProcessEndDate=@date,@error = 1,@insert_new_record=1
		--Raise an error with the details of the exception
		SELECT @ErrMsg = ERROR_MESSAGE(), @ErrSeverity = ERROR_SEVERITY()
		RAISERROR(@ErrMsg, @ErrSeverity, 1)
	END CATCH

END

GO
