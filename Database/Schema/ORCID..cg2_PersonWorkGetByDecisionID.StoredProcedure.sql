SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [ORCID.].[cg2_PersonWorkGetByDecisionID]
 
    @DecisionID  INT 

AS
 
    SELECT TOP 100 PERCENT
        [ORCID.].[PersonWork].[PersonWorkID]
        , [ORCID.].[PersonWork].[PersonID]
        , [ORCID.].[PersonWork].[PersonMessageID]
        , [ORCID.].[PersonWork].[DecisionID]
        , [ORCID.].[PersonWork].[WorkTitle]
        , [ORCID.].[PersonWork].[ShortDescription]
        , [ORCID.].[PersonWork].[WorkCitation]
        , [ORCID.].[PersonWork].[WorkType]
        , [ORCID.].[PersonWork].[URL]
        , [ORCID.].[PersonWork].[SubTitle]
        , [ORCID.].[PersonWork].[WorkCitationType]
        , [ORCID.].[PersonWork].[PubDate]
        , [ORCID.].[PersonWork].[PublicationMediaType]
        , [ORCID.].[PersonWork].[PubID]
    FROM
        [ORCID.].[PersonWork]
    WHERE
        [ORCID.].[PersonWork].[DecisionID] = @DecisionID




GO
