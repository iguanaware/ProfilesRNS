SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [RDF.].[Node](
	[NodeID] [bigint] IDENTITY(1,1) NOT NULL,
	[ValueHash] [binary](20) NOT NULL,
	[Language] [nvarchar](255) NULL,
	[DataType] [nvarchar](255) NULL,
	[Value] [nvarchar](max) NOT NULL,
	[InternalNodeMapID] [int] NULL,
	[ObjectType] [bit] NULL,
	[ViewSecurityGroup] [bigint] NULL,
	[EditSecurityGroup] [bigint] NULL,
 CONSTRAINT [PK__Node__72C60C4A] PRIMARY KEY CLUSTERED 
(
	[NodeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
CREATE UNIQUE NONCLUSTERED INDEX [idx_ValueHash] ON [RDF.].[Node] 
(
	[ValueHash] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO
CREATE FULLTEXT INDEX ON [RDF.].[Node](
[Value] LANGUAGE [English])
KEY INDEX [PK__Node__72C60C4A]ON [ft]
WITH CHANGE_TRACKING  AUTO
GO
