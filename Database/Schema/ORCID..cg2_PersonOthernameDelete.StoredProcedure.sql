SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [ORCID.].[cg2_PersonOthernameDelete]
 
    @PersonOthernameID  INT 

 
AS
 
    DECLARE @intReturnVal INT 
    SET @intReturnVal = 0
 
 
        DELETE FROM [ORCID.].[PersonOthername] WHERE         [ORCID.].[PersonOthername].[PersonOthernameID] = @PersonOthernameID

 
        SET @intReturnVal = @@error
        IF @intReturnVal <> 0
        BEGIN
            RAISERROR (N'An error occurred while deleting the PersonOthername record.', 11, 11); 
            RETURN @intReturnVal 
        END
    RETURN @intReturnVal



GO
