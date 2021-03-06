SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

 
CREATE PROCEDURE [ORCID.].[cg2_PersonWorkAdd]

    @PersonWorkID  INT =NULL OUTPUT 
    , @PersonID  INT 
    , @PersonMessageID  INT =NULL
    , @DecisionID  INT 
    , @WorkTitle  VARCHAR(MAX) 
    , @ShortDescription  VARCHAR(MAX) =NULL
    , @WorkCitation  VARCHAR(MAX) =NULL
    , @WorkType  VARCHAR(500) =NULL
    , @URL  VARCHAR(1000) =NULL
    , @SubTitle  VARCHAR(MAX) =NULL
    , @WorkCitationType  VARCHAR(500) =NULL
    , @PubDate  SMALLDATETIME =NULL
    , @PublicationMediaType  VARCHAR(500) =NULL
    , @PubID  NVARCHAR(50) 

AS


    DECLARE @intReturnVal INT 
    SET @intReturnVal = 0
    DECLARE @strReturn  Varchar(200) 
    SET @intReturnVal = 0
    DECLARE @intRecordLevelAuditTrailID INT 
    DECLARE @intFieldLevelAuditTrailID INT 
    DECLARE @intTableID INT 
    SET @intTableID = 3607
 
  
        INSERT INTO [ORCID.].[PersonWork]
        (
            [PersonID]
            , [PersonMessageID]
            , [DecisionID]
            , [WorkTitle]
            , [ShortDescription]
            , [WorkCitation]
            , [WorkType]
            , [URL]
            , [SubTitle]
            , [WorkCitationType]
            , [PubDate]
            , [PublicationMediaType]
            , [PubID]
        )
        (
            SELECT
            @PersonID
            , @PersonMessageID
            , @DecisionID
            , @WorkTitle
            , @ShortDescription
            , @WorkCitation
            , @WorkType
            , @URL
            , @SubTitle
            , @WorkCitationType
            , @PubDate
            , @PublicationMediaType
            , @PubID
        )
   
        SET @intReturnVal = @@error
        SET @PersonWorkID = @@IDENTITY
        IF @intReturnVal <> 0
        BEGIN
            RAISERROR (N'An error occurred while adding the PersonWork record.', 11, 11); 
            RETURN @intReturnVal 
        END



GO
