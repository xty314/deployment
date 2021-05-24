USE [master]
GO
/****** Object:  Database [ApplicationHost]    Script Date: 25/05/2021 8:05:35 am ******/
CREATE DATABASE [ApplicationHost]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'ApplicationHost', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.SQL2012\MSSQL\DATA\ApplicationHost.mdf' , SIZE = 4160KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'ApplicationHost_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.SQL2012\MSSQL\DATA\ApplicationHost_log.ldf' , SIZE = 1040KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [ApplicationHost] SET COMPATIBILITY_LEVEL = 110
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [ApplicationHost].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [ApplicationHost] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [ApplicationHost] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [ApplicationHost] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [ApplicationHost] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [ApplicationHost] SET ARITHABORT OFF 
GO
ALTER DATABASE [ApplicationHost] SET AUTO_CLOSE ON 
GO
ALTER DATABASE [ApplicationHost] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [ApplicationHost] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [ApplicationHost] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [ApplicationHost] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [ApplicationHost] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [ApplicationHost] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [ApplicationHost] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [ApplicationHost] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [ApplicationHost] SET  ENABLE_BROKER 
GO
ALTER DATABASE [ApplicationHost] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [ApplicationHost] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [ApplicationHost] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [ApplicationHost] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [ApplicationHost] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [ApplicationHost] SET READ_COMMITTED_SNAPSHOT ON 
GO
ALTER DATABASE [ApplicationHost] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [ApplicationHost] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [ApplicationHost] SET  MULTI_USER 
GO
ALTER DATABASE [ApplicationHost] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [ApplicationHost] SET DB_CHAINING OFF 
GO
ALTER DATABASE [ApplicationHost] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [ApplicationHost] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
USE [ApplicationHost]
GO
/****** Object:  Table [dbo].[card]    Script Date: 25/05/2021 8:05:35 am ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[card](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](50) NULL,
	[email] [nvarchar](50) NULL,
	[password] [nvarchar](150) NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[db_list]    Script Date: 25/05/2021 8:05:35 am ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[db_list](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](max) NULL,
	[conn_str] [nvarchar](max) NULL,
	[removable] [bit] NULL CONSTRAINT [DF_HostTenants_Delible]  DEFAULT ((0)),
	[install_db_id] [int] NULL CONSTRAINT [DF_HostTenants_NewDb]  DEFAULT ((0)),
	[creator] [int] NULL,
	[create_date] [datetime] NULL CONSTRAINT [DF_HostTenants_create_date]  DEFAULT (getdate()),
	[update_date] [datetime] NULL,
 CONSTRAINT [PK_HostTenants] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[git_repository]    Script Date: 25/05/2021 8:05:35 am ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[git_repository](
	[id] [int] NULL,
	[url] [nvarchar](50) NOT NULL,
	[description] [ntext] NOT NULL,
	[name] [nvarchar](50) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[install_db]    Script Date: 25/05/2021 8:05:35 am ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[install_db](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](50) NOT NULL,
	[conn_str] [nvarchar](max) NOT NULL,
	[location] [nvarchar](50) NOT NULL,
	[description] [nvarchar](max) NULL,
	[created_date] [datetime] NULL CONSTRAINT [DF_table_a_created_date]  DEFAULT (getdate()),
	[last_updated_date] [datetime] NULL,
	[removable] [bit] NULL CONSTRAINT [DF_install_db_removable]  DEFAULT ((0))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[script]    Script Date: 25/05/2021 8:05:35 am ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[script](
	[id] [int] NULL,
	[name] [nvarchar](50) NULL,
	[uploader] [int] NULL,
	[upload_date] [datetime] NULL,
	[description] [ntext] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[script_record]    Script Date: 25/05/2021 8:05:35 am ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[script_record](
	[id] [int] NULL,
	[script_id] [int] NULL,
	[db_id] [int] NULL,
	[run_date] [datetime] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[setting]    Script Date: 25/05/2021 8:05:35 am ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[setting](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](max) NULL,
	[value] [nvarchar](max) NULL,
	[description] [nvarchar](max) NULL,
	[type] [nvarchar](max) NULL,
	[title] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[web_app]    Script Date: 25/05/2021 8:05:35 am ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[web_app](
	[id] [int] NULL,
	[directory] [nvarchar](50) NULL,
	[db_id] [int] NULL,
	[git_id] [int] NULL,
	[creator] [int] NULL
) ON [PRIMARY]

GO
SET IDENTITY_INSERT [dbo].[card] ON 

INSERT [dbo].[card] ([id], [name], [email], [password]) VALUES (1, N'support', N'support@eznz.com', N'1B8B508C51038450B13789A7F7B031F6')
SET IDENTITY_INSERT [dbo].[card] OFF
SET IDENTITY_INSERT [dbo].[db_list] ON 

INSERT [dbo].[db_list] ([Id], [name], [conn_str], [removable], [install_db_id], [creator], [create_date], [update_date]) VALUES (1, N'd', N'd', 0, 0, NULL, CAST(N'2021-05-20 21:35:36.213' AS DateTime), NULL)
INSERT [dbo].[db_list] ([Id], [name], [conn_str], [removable], [install_db_id], [creator], [create_date], [update_date]) VALUES (5, N'rst374cloud', N'Server=localhost\SQL2012;Database=rst374cloud;User Id=eznz;password=9seqxtf7', 0, 1, 1, CAST(N'2021-05-24 22:04:03.583' AS DateTime), NULL)
SET IDENTITY_INSERT [dbo].[db_list] OFF
SET IDENTITY_INSERT [dbo].[install_db] ON 

INSERT [dbo].[install_db] ([id], [name], [conn_str], [location], [description], [created_date], [last_updated_date], [removable]) VALUES (1, N'rst374cloud', N'Server=localhost\SQL2012;Database=rst374cloud;User Id=eznz;password=9seqxtf7', N'dd', NULL, CAST(N'2021-05-24 22:13:09.167' AS DateTime), NULL, 0)
INSERT [dbo].[install_db] ([id], [name], [conn_str], [location], [description], [created_date], [last_updated_date], [removable]) VALUES (2, N'rst374cloud', N'Server=localhost\SQL2012;Database=rst374cloud;User Id=eznz;password=9seqxtf7', N'D:\\db\\restore\\mreport.bak', N'test', CAST(N'2021-05-24 22:44:43.023' AS DateTime), NULL, 0)
SET IDENTITY_INSERT [dbo].[install_db] OFF
SET IDENTITY_INSERT [dbo].[setting] ON 

INSERT [dbo].[setting] ([id], [name], [value], [description], [type], [title]) VALUES (1, N'install_db_location', N'D:\\db\\restore\\mreport.bak', N'安装数据库位置', N'string', N'Installation DB Location')
INSERT [dbo].[setting] ([id], [name], [value], [description], [type], [title]) VALUES (2, N'db_server', N'localhost\SQL2012', N'默认数据库服务器，例 localhost\SQL2012', N'string', N'DB Server Location')
SET IDENTITY_INSERT [dbo].[setting] OFF
USE [master]
GO
ALTER DATABASE [ApplicationHost] SET  READ_WRITE 
GO
