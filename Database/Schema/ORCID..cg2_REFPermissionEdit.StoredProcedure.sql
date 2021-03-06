SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

 
CREATE PROCEDURE [ORCID.].[cg2_REFPermissionEdit]

    @PermissionID  INT =NULL OUTPUT 
    , @PermissionScope  VARCHAR(100) 
    , @PermissionDescription  VARCHAR(500) 
    , @MethodAndRequest  VARCHAR(100) =NULL
    , @SuccessMessage  VARCHAR(1000) =NULL
    , @FailedMessage  VARCHAR(1000) =NULL

AS


    DECLARE @intReturnVal INT 
    SET @intReturnVal = 0
    DECLARE @strReturn  Varchar(200) 
    SET @intReturnVal = 0
    DECLARE @intRecordLevelAuditTrailID INT 
    DECLARE @intFieldLevelAuditTrailID INT 
    DECLARE @intTableID INT 
    SET @intTableID = 3722
 
  
        UPDATE [ORCID.].[REF_Permission]
        SET
            [PermissionScope] = @PermissionScope
            , [PermissionDescription] = @PermissionDescription
            , [MethodAndRequest] = @MethodAndRequest
            , [SuccessMessage] = @SuccessMessage
            , [FailedMessage] = @FailedMessage
        FROM
            [ORCID.].[REF_Permission]
        WHERE
        [ORCID.].[REF_Permission].[PermissionID] = @PermissionID

        
        SET @intReturnVal = @@error
        IF @intReturnVal <> 0
        BEGIN
            RAISERROR (N'An error occurred while editing the REF_Permission record.', 11, 11); 
            RETURN @intReturnVal 
        END



GO
