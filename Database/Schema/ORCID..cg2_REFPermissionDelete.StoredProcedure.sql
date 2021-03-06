SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [ORCID.].[cg2_REFPermissionDelete]
 
    @PermissionID  INT 

 
AS
 
    DECLARE @intReturnVal INT 
    SET @intReturnVal = 0
 
 
        DELETE FROM [ORCID.].[REF_Permission] WHERE         [ORCID.].[REF_Permission].[PermissionID] = @PermissionID

 
        SET @intReturnVal = @@error
        IF @intReturnVal <> 0
        BEGIN
            RAISERROR (N'An error occurred while deleting the REF_Permission record.', 11, 11); 
            RETURN @intReturnVal 
        END
    RETURN @intReturnVal



GO
