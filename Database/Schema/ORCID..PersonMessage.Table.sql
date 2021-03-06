SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
CREATE TABLE [ORCID.].[PersonMessage](
	[PersonMessageID] [int] IDENTITY(1,1) NOT NULL,
	[PersonID] [int] NOT NULL,
	[XML_Sent] [varchar](max) NULL,
	[XML_Response] [varchar](max) NULL,
	[ErrorMessage] [varchar](1000) NULL,
	[HttpResponseCode] [varchar](50) NULL,
	[MessagePostSuccess] [bit] NULL,
	[RecordStatusID] [tinyint] NULL,
	[PermissionID] [tinyint] NULL,
	[RequestURL] [varchar](1000) NULL,
	[HeaderPost] [varchar](1000) NULL,
	[UserMessage] [varchar](2000) NULL,
	[PostDate] [smalldatetime] NULL,
 CONSTRAINT [PK_PersonMessage] PRIMARY KEY CLUSTERED 
(
	[PersonMessageID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [ORCID.].[PersonMessage]  WITH CHECK ADD  CONSTRAINT [FK_PersonMessage_Person] FOREIGN KEY([PersonID])
REFERENCES [ORCID.].[Person] ([PersonID])
GO
ALTER TABLE [ORCID.].[PersonMessage] CHECK CONSTRAINT [FK_PersonMessage_Person]
GO
ALTER TABLE [ORCID.].[PersonMessage]  WITH CHECK ADD  CONSTRAINT [FK_PersonMessage_RecordStatusID] FOREIGN KEY([RecordStatusID])
REFERENCES [ORCID.].[REF_RecordStatus] ([RecordStatusID])
GO
ALTER TABLE [ORCID.].[PersonMessage] CHECK CONSTRAINT [FK_PersonMessage_RecordStatusID]
GO
ALTER TABLE [ORCID.].[PersonMessage]  WITH CHECK ADD  CONSTRAINT [FK_PersonMessage_REF_Permission] FOREIGN KEY([PermissionID])
REFERENCES [ORCID.].[REF_Permission] ([PermissionID])
GO
ALTER TABLE [ORCID.].[PersonMessage] CHECK CONSTRAINT [FK_PersonMessage_REF_Permission]
GO
