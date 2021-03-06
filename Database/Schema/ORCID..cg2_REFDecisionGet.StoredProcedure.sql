SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [ORCID.].[cg2_REFDecisionGet]
 
    @DecisionID  INT 

AS
 
    SELECT TOP 100 PERCENT
        [ORCID.].[REF_Decision].[DecisionID]
        , [ORCID.].[REF_Decision].[DecisionDescription]
        , [ORCID.].[REF_Decision].[DecisionDescriptionLong]
    FROM
        [ORCID.].[REF_Decision]
    WHERE
        [ORCID.].[REF_Decision].[DecisionID] = @DecisionID




GO
