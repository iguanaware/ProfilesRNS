SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [ORCID.].[cg2_PersonGetByInternalUsername]
 
    @InternalUsername  NVARCHAR(100) 

AS
 
    SELECT TOP 100 PERCENT
        [ORCID.].[Person].[PersonID]
        , [ORCID.].[Person].[InternalUsername]
        , [ORCID.].[Person].[PersonStatusTypeID]
        , [ORCID.].[Person].[CreateUnlessOptOut]
        , [ORCID.].[Person].[ORCID]
        , [ORCID.].[Person].[ORCIDRecorded]
        , [ORCID.].[Person].[FirstName]
        , [ORCID.].[Person].[LastName]
        , [ORCID.].[Person].[PublishedName]
        , [ORCID.].[Person].[EmailDecisionID]
        , [ORCID.].[Person].[EmailAddress]
        , [ORCID.].[Person].[AlternateEmailDecisionID]
        , [ORCID.].[Person].[AgreementAcknowledged]
        , [ORCID.].[Person].[Biography]
        , [ORCID.].[Person].[BiographyDecisionID]
    FROM
        [ORCID.].[Person]
    WHERE
        [ORCID.].[Person].[InternalUsername] = @InternalUsername




GO
