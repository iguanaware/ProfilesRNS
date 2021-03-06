SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [ORCID.].[cg2_OrganizationInstitutionGet]
 
    @InstitutionID  INT 

AS
 
    SELECT TOP 100 PERCENT
        [Profile.Data].[Organization.Institution].[InstitutionID]
        , [Profile.Data].[Organization.Institution].[InstitutionName]
        , [Profile.Data].[Organization.Institution].[InstitutionAbbreviation]
  --      , [Profile.Data].[Organization.Institution].[City]
  --      , [Profile.Data].[Organization.Institution].[State]
  --      , [Profile.Data].[Organization.Institution].[Country]
  --      , [Profile.Data].[Organization.Institution].[RingGoldID]
    FROM
        [Profile.Data].[Organization.Institution]
    WHERE
        [Profile.Data].[Organization.Institution].[InstitutionID] = @InstitutionID



GO
