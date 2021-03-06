SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

 
CREATE PROCEDURE [ORCID.].[cg2_PersonMessageEdit]

    @PersonMessageID  INT =NULL OUTPUT 
    , @PersonID  INT 
    , @XML_Sent  VARCHAR(MAX) =NULL
    , @XML_Response  VARCHAR(MAX) =NULL
    , @ErrorMessage  VARCHAR(1000) =NULL
    , @HttpResponseCode  VARCHAR(50) =NULL
    , @MessagePostSuccess  BIT =NULL
    , @RecordStatusID  INT =NULL
    , @PermissionID  INT =NULL
    , @RequestURL  VARCHAR(1000) =NULL
    , @HeaderPost  VARCHAR(1000) =NULL
    , @UserMessage  VARCHAR(2000) =NULL
    , @PostDate  SMALLDATETIME =NULL

AS


    DECLARE @intReturnVal INT 
    SET @intReturnVal = 0
    DECLARE @strReturn  Varchar(200) 
    SET @intReturnVal = 0
    DECLARE @intRecordLevelAuditTrailID INT 
    DECLARE @intFieldLevelAuditTrailID INT 
    DECLARE @intTableID INT 
    SET @intTableID = 3575
 
  
        UPDATE [ORCID.].[PersonMessage]
        SET
            [PersonID] = @PersonID
            , [XML_Sent] = @XML_Sent
            , [XML_Response] = @XML_Response
            , [ErrorMessage] = @ErrorMessage
            , [HttpResponseCode] = @HttpResponseCode
            , [MessagePostSuccess] = @MessagePostSuccess
            , [RecordStatusID] = @RecordStatusID
            , [PermissionID] = @PermissionID
            , [RequestURL] = @RequestURL
            , [HeaderPost] = @HeaderPost
            , [UserMessage] = @UserMessage
            , [PostDate] = @PostDate
        FROM
            [ORCID.].[PersonMessage]
        WHERE
        [ORCID.].[PersonMessage].[PersonMessageID] = @PersonMessageID

        
        SET @intReturnVal = @@error
        IF @intReturnVal <> 0
        BEGIN
            RAISERROR (N'An error occurred while editing the PersonMessage record.', 11, 11); 
            RETURN @intReturnVal 
        END



GO
