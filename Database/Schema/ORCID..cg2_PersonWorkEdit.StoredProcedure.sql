SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

 
CREATE PROCEDURE [ORCID.].[cg2_PersonWorkEdit]

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
 
  
        UPDATE [ORCID.].[PersonWork]
        SET
            [PersonID] = @PersonID
            , [PersonMessageID] = @PersonMessageID
            , [DecisionID] = @DecisionID
            , [WorkTitle] = @WorkTitle
            , [ShortDescription] = @ShortDescription
            , [WorkCitation] = @WorkCitation
            , [WorkType] = @WorkType
            , [URL] = @URL
            , [SubTitle] = @SubTitle
            , [WorkCitationType] = @WorkCitationType
            , [PubDate] = @PubDate
            , [PublicationMediaType] = @PublicationMediaType
            , [PubID] = @PubID
        FROM
            [ORCID.].[PersonWork]
        WHERE
        [ORCID.].[PersonWork].[PersonWorkID] = @PersonWorkID

        
        SET @intReturnVal = @@error
        IF @intReturnVal <> 0
        BEGIN
            RAISERROR (N'An error occurred while editing the PersonWork record.', 11, 11); 
            RETURN @intReturnVal 
        END



GO
