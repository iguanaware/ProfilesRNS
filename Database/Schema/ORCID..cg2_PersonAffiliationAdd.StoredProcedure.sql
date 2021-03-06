SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

 
CREATE PROCEDURE [ORCID.].[cg2_PersonAffiliationAdd]

    @PersonAffiliationID  INT =NULL OUTPUT 
    , @ProfilesID  INT 
    , @AffiliationTypeID  INT 
    , @PersonID  INT 
    , @PersonMessageID  INT =NULL
    , @DecisionID  INT 
    , @DepartmentName  VARCHAR(4000) =NULL
    , @RoleTitle  VARCHAR(200) =NULL
    , @StartDate  SMALLDATETIME =NULL
    , @EndDate  SMALLDATETIME =NULL
    , @OrganizationName  VARCHAR(4000) 
    , @OrganizationCity  VARCHAR(4000) =NULL
    , @OrganizationRegion  VARCHAR(2) =NULL
    , @OrganizationCountry  VARCHAR(2) =NULL
    , @DisambiguationID  VARCHAR(500) =NULL
    , @DisambiguationSource  VARCHAR(500) =NULL

AS


    DECLARE @intReturnVal INT 
    SET @intReturnVal = 0
    DECLARE @strReturn  Varchar(200) 
    SET @intReturnVal = 0
    DECLARE @intRecordLevelAuditTrailID INT 
    DECLARE @intFieldLevelAuditTrailID INT 
    DECLARE @intTableID INT 
    SET @intTableID = 4467
 
  
        INSERT INTO [ORCID.].[PersonAffiliation]
        (
            [ProfilesID]
            , [AffiliationTypeID]
            , [PersonID]
            , [PersonMessageID]
            , [DecisionID]
            , [DepartmentName]
            , [RoleTitle]
            , [StartDate]
            , [EndDate]
            , [OrganizationName]
            , [OrganizationCity]
            , [OrganizationRegion]
            , [OrganizationCountry]
            , [DisambiguationID]
            , [DisambiguationSource]
        )
        (
            SELECT
            @ProfilesID
            , @AffiliationTypeID
            , @PersonID
            , @PersonMessageID
            , @DecisionID
            , @DepartmentName
            , @RoleTitle
            , @StartDate
            , @EndDate
            , @OrganizationName
            , @OrganizationCity
            , @OrganizationRegion
            , @OrganizationCountry
            , @DisambiguationID
            , @DisambiguationSource
        )
   
        SET @intReturnVal = @@error
        SET @PersonAffiliationID = @@IDENTITY
        IF @intReturnVal <> 0
        BEGIN
            RAISERROR (N'An error occurred while adding the PersonAffiliation record.', 11, 11); 
            RETURN @intReturnVal 
        END



GO
