SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [ORCID.].[cg2_PersonAffiliationGetByPersonID]
 
    @PersonID  INT 

AS
 
    SELECT TOP 100 PERCENT
        [ORCID.].[PersonAffiliation].[PersonAffiliationID]
        , [ORCID.].[PersonAffiliation].[ProfilesID]
        , [ORCID.].[PersonAffiliation].[AffiliationTypeID]
        , [ORCID.].[PersonAffiliation].[PersonID]
        , [ORCID.].[PersonAffiliation].[PersonMessageID]
        , [ORCID.].[PersonAffiliation].[DecisionID]
        , [ORCID.].[PersonAffiliation].[DepartmentName]
        , [ORCID.].[PersonAffiliation].[RoleTitle]
        , [ORCID.].[PersonAffiliation].[StartDate]
        , [ORCID.].[PersonAffiliation].[EndDate]
        , [ORCID.].[PersonAffiliation].[OrganizationName]
        , [ORCID.].[PersonAffiliation].[OrganizationCity]
        , [ORCID.].[PersonAffiliation].[OrganizationRegion]
        , [ORCID.].[PersonAffiliation].[OrganizationCountry]
        , [ORCID.].[PersonAffiliation].[DisambiguationID]
        , [ORCID.].[PersonAffiliation].[DisambiguationSource]
    FROM
        [ORCID.].[PersonAffiliation]
    WHERE
        [ORCID.].[PersonAffiliation].[PersonID] = @PersonID




GO
