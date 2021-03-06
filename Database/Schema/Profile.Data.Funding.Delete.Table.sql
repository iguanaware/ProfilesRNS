SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO

CREATE TABLE [Profile.Data].[Funding.Delete](
	[FundingRoleID] [varchar](50) NOT NULL,
	[PersonID] [int] NULL,
	[FundingAgreementID] [varchar](50) NULL,
	[Source] varchar(20) not null,
	[FundingID] [varchar](50) NULL,
	[FundingID2] [varchar](50) NULL,
PRIMARY KEY CLUSTERED 
(
	[FundingRoleID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] 
GO
