SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [ORCID.].[cg2_PersonURLGetByPersonIDAndURL]
 
    @PersonID  INT 
    , @URL  VARCHAR(2000) 

AS
 
    SELECT TOP 100 PERCENT
        [ORCID.].[PersonURL].[PersonURLID]
        , [ORCID.].[PersonURL].[PersonID]
        , [ORCID.].[PersonURL].[PersonMessageID]
        , [ORCID.].[PersonURL].[URLName]
        , [ORCID.].[PersonURL].[URL]
        , [ORCID.].[PersonURL].[DecisionID]
    FROM
        [ORCID.].[PersonURL]
    WHERE
        [ORCID.].[PersonURL].[PersonID] = @PersonID
        AND [ORCID.].[PersonURL].[URL] = @URL




GO
