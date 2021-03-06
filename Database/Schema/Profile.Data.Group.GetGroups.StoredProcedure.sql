SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [Profile.Data].[Group.GetGroups]
	@SortBy VARCHAR(50)='GroupName',
	@SortDesc BIT=0,
	@ShowDeletedGroups BIT=0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @sql NVARCHAR(MAX)

	SELECT @sql = 'SELECT * FROM [Profile.Data].[vwGroup.GeneralWithDeleted] '
				+(CASE WHEN @ShowDeletedGroups = 0 THEN 'WHERE ViewSecurityGroup <> 0 '
					WHEN @ShowDeletedGroups = 1 THEN 'WHERE ViewSecurityGroup = 0 '
					ELSE '' END)
				+'ORDER BY '
				+(CASE WHEN @SortBy IN ('GroupID','CreateDate','ViewSecurityGroupName','GroupNodeID') 
					THEN @SortBy + (CASE WHEN @SortDesc=1 THEN ' DESC' ELSE '' END) + ', ' 
					ELSE '' END)
				+'GroupName'
				+(CASE WHEN @SortBy='GroupID' THEN '' ELSE ', GroupID' END)

	EXEC sp_executesql @sql

END

GO
