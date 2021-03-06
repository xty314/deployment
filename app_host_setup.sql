USE [master]
GO
/****** Object:  Database [app_host]    Script Date: 24/08/2021 12:22:34 pm ******/
CREATE DATABASE [app_host]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'app_host', FILENAME = N'D:\SQL2012\MSSQL11.SQL2012\MSSQL\DATA\app_host.mdf' , SIZE = 4160KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'app_host_log', FILENAME = N'D:\SQL2012\MSSQL11.SQL2012\MSSQL\DATA\app_host_log.ldf' , SIZE = 4288KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [app_host] SET COMPATIBILITY_LEVEL = 110
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [app_host].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [app_host] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [app_host] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [app_host] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [app_host] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [app_host] SET ARITHABORT OFF 
GO
ALTER DATABASE [app_host] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [app_host] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [app_host] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [app_host] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [app_host] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [app_host] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [app_host] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [app_host] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [app_host] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [app_host] SET  ENABLE_BROKER 
GO
ALTER DATABASE [app_host] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [app_host] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [app_host] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [app_host] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [app_host] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [app_host] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [app_host] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [app_host] SET RECOVERY FULL 
GO
ALTER DATABASE [app_host] SET  MULTI_USER 
GO
ALTER DATABASE [app_host] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [app_host] SET DB_CHAINING OFF 
GO
ALTER DATABASE [app_host] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [app_host] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
USE [app_host]
GO
/****** Object:  Table [dbo].[card]    Script Date: 24/08/2021 12:22:34 pm ******/
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
/****** Object:  Table [dbo].[db_list]    Script Date: 24/08/2021 12:22:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[db_list](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](max) NULL,
	[conn_str] [nvarchar](max) NULL,
	[removable] [bit] NULL,
	[install_db_id] [int] NULL,
	[creator] [int] NULL,
	[create_date] [datetime] NULL,
	[update_date] [datetime] NULL,
	[dev] [bit] NOT NULL,
 CONSTRAINT [PK_HostTenants] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[git_repository]    Script Date: 24/08/2021 12:22:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[git_repository](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[url] [nvarchar](80) NOT NULL,
	[description] [ntext] NOT NULL,
	[name] [nvarchar](50) NULL,
	[private] [bit] NULL,
	[del] [bit] NOT NULL CONSTRAINT [DF_git_repository_del]  DEFAULT ((0))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[install_db]    Script Date: 24/08/2021 12:22:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[install_db](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](50) NOT NULL,
	[conn_str] [nvarchar](max) NOT NULL,
	[location] [nvarchar](max) NOT NULL,
	[description] [nvarchar](max) NULL,
	[create_date] [datetime] NULL CONSTRAINT [DF_table_a_created_date]  DEFAULT (getdate()),
	[last_update_date] [datetime] NULL,
	[removable] [bit] NULL CONSTRAINT [DF_install_db_removable]  DEFAULT ((0))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[mreport]    Script Date: 24/08/2021 12:22:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[mreport](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[app_id] [int] NULL,
	[name] [nvarchar](max) NULL,
	[description] [nvarchar](max) NULL,
	[url] [nvarchar](max) NULL,
	[location] [nvarchar](max) NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[script]    Script Date: 24/08/2021 12:22:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[script](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](50) NULL,
	[location] [nvarchar](max) NULL,
	[uploader] [int] NULL,
	[upload_date] [datetime] NULL,
	[description] [ntext] NOT NULL,
	[del] [bit] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[script_record]    Script Date: 24/08/2021 12:22:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[script_record](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[script_id] [int] NULL,
	[db_id] [int] NULL,
	[execute_date] [datetime] NULL,
	[install_db_id] [int] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[setting]    Script Date: 24/08/2021 12:22:34 pm ******/
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
/****** Object:  Table [dbo].[web_app]    Script Date: 24/08/2021 12:22:34 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[web_app](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](50) NULL,
	[description] [ntext] NULL,
	[location] [nvarchar](100) NULL,
	[db_id] [int] NULL,
	[repo_id] [int] NULL,
	[creator] [int] NULL,
	[create_date] [datetime] NOT NULL,
	[last_update_date] [datetime] NULL,
	[url] [nvarchar](50) NULL,
	[deploy] [bit] NOT NULL,
	[customize] [bit] NOT NULL,
	[removable] [bit] NOT NULL,
	[dev] [bit] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET IDENTITY_INSERT [dbo].[card] ON 

INSERT [dbo].[card] ([id], [name], [email], [password]) VALUES (1, N'support', N'support@eznz.com', N'1B8B508C51038450B13789A7F7B031F6')
SET IDENTITY_INSERT [dbo].[card] OFF
SET IDENTITY_INSERT [dbo].[git_repository] ON 

INSERT [dbo].[git_repository] ([id], [url], [description], [name], [private], [del]) VALUES (1, N'https://github.com/GPOSNZ/gpos-cloud-rst-v3.7.4.git', N'源码在239 
D:\html\webhost\rst374cloud', N'rst374 cloud', 1, 0)
INSERT [dbo].[git_repository] ([id], [url], [description], [name], [private], [del]) VALUES (6, N'https://github.com/xty314/deployment.git', N'', N'test', 0, 1)
INSERT [dbo].[git_repository] ([id], [url], [description], [name], [private], [del]) VALUES (7, N'https://github.com/GPOSNZ/gpos-cloud-multi-mreport-v1.0.git', N'', N'mreport', 1, 1)
INSERT [dbo].[git_repository] ([id], [url], [description], [name], [private], [del]) VALUES (5, N'https://github.com/xty314/GPOS.RST.CLOUD.git', N'', N'cloudtest', 0, 1)
SET IDENTITY_INSERT [dbo].[git_repository] OFF
SET IDENTITY_INSERT [dbo].[install_db] ON 

INSERT [dbo].[install_db] ([id], [name], [conn_str], [location], [description], [create_date], [last_update_date], [removable]) VALUES (1, N'rst374cloud_app_install', N'Server=192.168.1.248\SQL2012;Database=rst374cloud_app_install;User Id=eznz;password=9seqxtf7', N'E:\239AppDatabase\install\rst374cloud_app_install.bak', N'rst374cloud 安装数据库', CAST(N'2021-06-09 13:32:52.150' AS DateTime), CAST(N'2021-07-06 14:12:28.747' AS DateTime), 0)
SET IDENTITY_INSERT [dbo].[install_db] OFF
SET IDENTITY_INSERT [dbo].[setting] ON 

INSERT [dbo].[setting] ([id], [name], [value], [description], [type], [title]) VALUES (1, N'install_db_location', N'E:\239AppDatabase\install', N'安装数据库位置,该文件在数据库服务器上', N'string', N'Installation DB Location')
INSERT [dbo].[setting] ([id], [name], [value], [description], [type], [title]) VALUES (2, N'db_server', N'192.168.1.248\SQL2012', N'默认数据库服务器，例 localhost\SQL2012', N'string', N'DB Server Location')
INSERT [dbo].[setting] ([id], [name], [value], [description], [type], [title]) VALUES (3, N'app_install_location', N'D:\html\apphost', N'git 下载保存的目录，该目录应该位于iis服务器上', N'string', N'APP installation location')
INSERT [dbo].[setting] ([id], [name], [value], [description], [type], [title]) VALUES (4, N'test', N'1', N'test desc', N'bool', N'test title')
INSERT [dbo].[setting] ([id], [name], [value], [description], [type], [title]) VALUES (5, N'cloud_sync_api', N'http://api.gpos.nz/setup/{0}/sync/api/auth', N'rst374cloud sync api ', N'string', N'Sync Api')
INSERT [dbo].[setting] ([id], [name], [value], [description], [type], [title]) VALUES (6, N'cloud_mreport_api', N'http://api.gpos.nz/setup/{0}/mreport/', N'rst374cloud mreport api ', N'string', N'Mreport Api')
INSERT [dbo].[setting] ([id], [name], [value], [description], [type], [title]) VALUES (7, N'db_backup_location', N'E:\239AppDatabase\backup', N'备份数据库位置', N'string', N'Backup DB Location')
INSERT [dbo].[setting] ([id], [name], [value], [description], [type], [title]) VALUES (8, N'mreport_root_path', N'D:\html\webhost\mreport', N'mreport 根目录，位于239', N'string', N'Mreport Root Path')
INSERT [dbo].[setting] ([id], [name], [value], [description], [type], [title]) VALUES (9, N'mreport_url', N'http://mreport.gpos.nz/m/{0}', N'mreport 地址格式', N'string', N'Mreport Url Format')
INSERT [dbo].[setting] ([id], [name], [value], [description], [type], [title]) VALUES (10, N'cloud_ecom_api', N'http://api.gpos.nz/setup/{0}/ecom', N'ecom api', N'string', N'Ecom Api')
SET IDENTITY_INSERT [dbo].[setting] OFF
ALTER TABLE [dbo].[db_list] ADD  CONSTRAINT [DF_HostTenants_Delible]  DEFAULT ((0)) FOR [removable]
GO
ALTER TABLE [dbo].[db_list] ADD  CONSTRAINT [DF_HostTenants_NewDb]  DEFAULT ((0)) FOR [install_db_id]
GO
ALTER TABLE [dbo].[db_list] ADD  CONSTRAINT [DF_HostTenants_create_date]  DEFAULT (getdate()) FOR [create_date]
GO
ALTER TABLE [dbo].[db_list] ADD  CONSTRAINT [DF_db_list_dev]  DEFAULT ((0)) FOR [dev]
GO
ALTER TABLE [dbo].[script] ADD  CONSTRAINT [DF_script_upload_date]  DEFAULT (getdate()) FOR [upload_date]
GO
ALTER TABLE [dbo].[script] ADD  CONSTRAINT [DF_script_del]  DEFAULT ((0)) FOR [del]
GO
ALTER TABLE [dbo].[script_record] ADD  CONSTRAINT [DF_script_record_execute_date]  DEFAULT (getdate()) FOR [execute_date]
GO
ALTER TABLE [dbo].[web_app] ADD  CONSTRAINT [DF_web_app_create_date]  DEFAULT (getdate()) FOR [create_date]
GO
ALTER TABLE [dbo].[web_app] ADD  CONSTRAINT [DF_web_app_deploy]  DEFAULT ((0)) FOR [deploy]
GO
ALTER TABLE [dbo].[web_app] ADD  CONSTRAINT [DF_web_app_customize]  DEFAULT ((0)) FOR [customize]
GO
ALTER TABLE [dbo].[web_app] ADD  CONSTRAINT [DF_web_app_removable]  DEFAULT ((0)) FOR [removable]
GO
ALTER TABLE [dbo].[web_app] ADD  CONSTRAINT [DF_web_app_dev]  DEFAULT ((0)) FOR [dev]
GO
USE [master]
GO
ALTER DATABASE [app_host] SET  READ_WRITE 
GO
