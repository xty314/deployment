USE [master]
GO
/****** Object:  Database [app_host]    Script Date: 7/07/2021 12:20:46 pm ******/
CREATE DATABASE [app_host]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'app_host', FILENAME = N'D:\SQL2012\MSSQL11.SQL2012\MSSQL\DATA\app_host.mdf' , SIZE = 4160KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'app_host_log', FILENAME = N'D:\SQL2012\MSSQL11.SQL2012\MSSQL\DATA\app_host_log.ldf' , SIZE = 2368KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
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
/****** Object:  Table [dbo].[card]    Script Date: 7/07/2021 12:20:46 pm ******/
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
/****** Object:  Table [dbo].[db_list]    Script Date: 7/07/2021 12:20:46 pm ******/
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
	[dev] [bit] NOT NULL CONSTRAINT [DF_db_list_dev]  DEFAULT ((0)),
 CONSTRAINT [PK_HostTenants] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[git_repository]    Script Date: 7/07/2021 12:20:46 pm ******/
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
/****** Object:  Table [dbo].[install_db]    Script Date: 7/07/2021 12:20:46 pm ******/
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
/****** Object:  Table [dbo].[mreport]    Script Date: 7/07/2021 12:20:46 pm ******/
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
/****** Object:  Table [dbo].[script]    Script Date: 7/07/2021 12:20:46 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[script](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](50) NULL,
	[location] [nvarchar](max) NULL,
	[uploader] [int] NULL,
	[upload_date] [datetime] NULL CONSTRAINT [DF_script_upload_date]  DEFAULT (getdate()),
	[description] [ntext] NOT NULL,
	[del] [bit] NULL CONSTRAINT [DF_script_del]  DEFAULT ((0))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[script_record]    Script Date: 7/07/2021 12:20:46 pm ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[script_record](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[script_id] [int] NULL,
	[db_id] [int] NULL,
	[execute_date] [datetime] NULL CONSTRAINT [DF_script_record_execute_date]  DEFAULT (getdate()),
	[install_db_id] [int] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[setting]    Script Date: 7/07/2021 12:20:46 pm ******/
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
/****** Object:  Table [dbo].[web_app]    Script Date: 7/07/2021 12:20:46 pm ******/
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
	[create_date] [datetime] NOT NULL CONSTRAINT [DF_web_app_create_date]  DEFAULT (getdate()),
	[last_update_date] [datetime] NULL,
	[url] [nvarchar](50) NULL,
	[deploy] [bit] NOT NULL CONSTRAINT [DF_web_app_deploy]  DEFAULT ((0)),
	[customize] [bit] NOT NULL CONSTRAINT [DF_web_app_customize]  DEFAULT ((0)),
	[removable] [bit] NOT NULL CONSTRAINT [DF_web_app_removable]  DEFAULT ((0)),
	[dev] [bit] NOT NULL CONSTRAINT [DF_web_app_dev]  DEFAULT ((0))
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET IDENTITY_INSERT [dbo].[card] ON 

INSERT [dbo].[card] ([id], [name], [email], [password]) VALUES (1, N'support', N'support@eznz.com', N'1B8B508C51038450B13789A7F7B031F6')
SET IDENTITY_INSERT [dbo].[card] OFF
SET IDENTITY_INSERT [dbo].[db_list] ON 

INSERT [dbo].[db_list] ([Id], [name], [conn_str], [removable], [install_db_id], [creator], [create_date], [update_date], [dev]) VALUES (12, N'hanyang', N'Server=192.168.1.248\SQL2012;Database=hanyang_m;User Id=eznz;password=9seqxtf7', 0, 0, 1, CAST(N'2021-06-03 17:01:46.817' AS DateTime), CAST(N'2021-07-05 16:19:24.650' AS DateTime), 0)
INSERT [dbo].[db_list] ([Id], [name], [conn_str], [removable], [install_db_id], [creator], [create_date], [update_date], [dev]) VALUES (14, N'rst374cloud_248', N'Server=192.168.1.248\SQL2012;Database=rst374cloud_248;User Id=eznz;password=9seqxtf7', 0, 0, 1, CAST(N'2021-06-09 10:27:16.580' AS DateTime), CAST(N'2021-07-04 15:53:01.403' AS DateTime), 0)
INSERT [dbo].[db_list] ([Id], [name], [conn_str], [removable], [install_db_id], [creator], [create_date], [update_date], [dev]) VALUES (24, N'fresco_cloud12', N'Server=192.168.1.248\SQL2012;Database=fresco_cloud12;User Id=eznz;password=9seqxtf7', 0, 0, 1, CAST(N'2021-06-09 15:34:53.733' AS DateTime), CAST(N'2021-07-05 16:16:57.830' AS DateTime), 0)
INSERT [dbo].[db_list] ([Id], [name], [conn_str], [removable], [install_db_id], [creator], [create_date], [update_date], [dev]) VALUES (25, N'giantd', N'Server=192.168.1.248\SQL2012;Database=giantd_mreport;User Id=eznz;password=9seqxtf7', 0, 0, 1, CAST(N'2021-06-10 15:06:38.910' AS DateTime), CAST(N'2021-07-05 16:15:45.543' AS DateTime), 0)
INSERT [dbo].[db_list] ([Id], [name], [conn_str], [removable], [install_db_id], [creator], [create_date], [update_date], [dev]) VALUES (26, N'activata', N'Server=192.168.1.248\SQL2012;Database=activata_mreport;User Id=eznz;password=9seqxtf7', 0, 0, 1, CAST(N'2021-06-10 16:09:16.303' AS DateTime), CAST(N'2021-06-24 16:59:56.120' AS DateTime), 0)
INSERT [dbo].[db_list] ([Id], [name], [conn_str], [removable], [install_db_id], [creator], [create_date], [update_date], [dev]) VALUES (27, N'pxbutchery glenfield', N'Server=192.168.1.248\SQL2012;Database=pxbutchery;User Id=eznz;password=9seqxtf7', 0, 1, 1, CAST(N'2021-06-11 14:38:35.187' AS DateTime), CAST(N'2021-07-05 16:18:42.557' AS DateTime), 0)
SET IDENTITY_INSERT [dbo].[db_list] OFF
SET IDENTITY_INSERT [dbo].[git_repository] ON 

INSERT [dbo].[git_repository] ([id], [url], [description], [name], [private], [del]) VALUES (1, N'https://github.com/GPOSNZ/gpos-cloud-rst-v3.7.4.git', N'源码在239 
D:\html\webhost\rst374cloud', N'rst374 cloud', 1, 0)
INSERT [dbo].[git_repository] ([id], [url], [description], [name], [private], [del]) VALUES (5, N'https://github.com/xty314/GPOS.RST.CLOUD.git', N'', N'cloudtest', 0, 1)
SET IDENTITY_INSERT [dbo].[git_repository] OFF
SET IDENTITY_INSERT [dbo].[install_db] ON 

INSERT [dbo].[install_db] ([id], [name], [conn_str], [location], [description], [create_date], [last_update_date], [removable]) VALUES (1, N'rst374cloud_app_install', N'Server=192.168.1.248\SQL2012;Database=rst374cloud_app_install;User Id=eznz;password=9seqxtf7', N'E:\239AppDatabase\install\rst374cloud_app_install.bak', N'rst374cloud 安装数据库', CAST(N'2021-06-09 13:32:52.150' AS DateTime), CAST(N'2021-07-06 14:12:28.747' AS DateTime), 0)
SET IDENTITY_INSERT [dbo].[install_db] OFF
SET IDENTITY_INSERT [dbo].[mreport] ON 

INSERT [dbo].[mreport] ([id], [app_id], [name], [description], [url], [location]) VALUES (6, 14, N'rst374cloud', N'rst374cloud', N'http://mreport.gpos.nz/m/rst374cloud', N'D:\html\webhost\mreport\m\rst374cloud')
INSERT [dbo].[mreport] ([id], [app_id], [name], [description], [url], [location]) VALUES (7, 17, N'giantd', N'Giantd mreport', N'http://mreport.gpos.nz/m/giantd_mreport', N'D:\html\webhost\mreport\m\giantd_mreport')
INSERT [dbo].[mreport] ([id], [app_id], [name], [description], [url], [location]) VALUES (8, 12, N'hanyang', N'', N'http://mreport.gpos.nz/m/hanyang_m', N'D:\html\webhost\mreport\m\hanyang_m')
INSERT [dbo].[mreport] ([id], [app_id], [name], [description], [url], [location]) VALUES (9, 16, N'wistle', N'activata mreport', N'http://mreport.gpos.nz/m/wistle', N'D:\html\webhost\mreport\m\wistle')
INSERT [dbo].[mreport] ([id], [app_id], [name], [description], [url], [location]) VALUES (10, 13, N'fresco_mart', N'', N'http://mreport.gpos.nz/m/fresco_mart', N'D:\html\webhost\mreport\m\fresco_mart')
INSERT [dbo].[mreport] ([id], [app_id], [name], [description], [url], [location]) VALUES (11, 22, N'pxb', N'pxb butchery', N'http://mreport.gpos.nz/m/pxb', N'D:\html\webhost\mreport\m\pxb')
SET IDENTITY_INSERT [dbo].[mreport] OFF
SET IDENTITY_INSERT [dbo].[script] ON 

INSERT [dbo].[script] ([id], [name], [location], [uploader], [upload_date], [description], [del]) VALUES (1, N'test1', N'D:\html\webhost\deploy\script\test1.sql', 1, CAST(N'2021-06-09 13:40:43.047' AS DateTime), N'test1', 1)
INSERT [dbo].[script] ([id], [name], [location], [uploader], [upload_date], [description], [del]) VALUES (2, N'test2', N'D:\html\webhost\deploy\script\test2.sql', 1, CAST(N'2021-06-09 13:41:03.683' AS DateTime), N'test2', 1)
INSERT [dbo].[script] ([id], [name], [location], [uploader], [upload_date], [description], [del]) VALUES (3, N'test3', N'D:\html\webhost\deploy\script\test3.sql', 1, CAST(N'2021-06-09 13:41:19.770' AS DateTime), N'test3', 1)
INSERT [dbo].[script] ([id], [name], [location], [uploader], [upload_date], [description], [del]) VALUES (4, N'Add auth_code to Branch', N'D:\html\webhost\deploy\script\Add auth_code to Branch.sql', 1, CAST(N'2021-06-09 17:49:42.677' AS DateTime), N'在branch表中添加auth_code列', 1)
INSERT [dbo].[script] ([id], [name], [location], [uploader], [upload_date], [description], [del]) VALUES (5, N'Add auth_code to Branch', N'D:\html\webhost\deploy\script\ifij0zla.yfm.sql', 1, CAST(N'2021-06-09 17:52:18.700' AS DateTime), N'在branch表中添加auth_code列', 0)
INSERT [dbo].[script] ([id], [name], [location], [uploader], [upload_date], [description], [del]) VALUES (6, N'Add redeem points', N'D:\html\webhost\deploy\script\Add redeem points.sql', 1, CAST(N'2021-06-17 11:44:59.600' AS DateTime), N'add redeemed note & add redeem points settings', 0)
INSERT [dbo].[script] ([id], [name], [location], [uploader], [upload_date], [description], [del]) VALUES (8, N'add_TimeStampS_column_and_add_default_value', N'D:\html\webhost\deploy\script\add_TimeStampS_column_and_add_default_value.sql', 1, CAST(N'2021-07-05 12:34:07.953' AS DateTime), N'在updated_item表中添加TimeStampS列，并设置默认值，默认值为当前时间的时间戳', 0)
INSERT [dbo].[script] ([id], [name], [location], [uploader], [upload_date], [description], [del]) VALUES (7, N'Add pic into button and button_item', N'D:\html\webhost\deploy\script\Add pic into button and button_item.sql', 1, CAST(N'2021-06-24 16:42:28.983' AS DateTime), N'在button和button_item表中加入pic字段，将图片存入数据库，button表加code字段关联产品', 0)
SET IDENTITY_INSERT [dbo].[script] OFF
SET IDENTITY_INSERT [dbo].[script_record] ON 

INSERT [dbo].[script_record] ([id], [script_id], [db_id], [execute_date], [install_db_id]) VALUES (1, 7, 8, CAST(N'2021-06-04 15:55:30.770' AS DateTime), 0)
INSERT [dbo].[script_record] ([id], [script_id], [db_id], [execute_date], [install_db_id]) VALUES (2, 10, 8, CAST(N'2021-06-04 15:55:30.777' AS DateTime), 0)
INSERT [dbo].[script_record] ([id], [script_id], [db_id], [execute_date], [install_db_id]) VALUES (3, 7, 13, CAST(N'2021-06-04 15:55:30.787' AS DateTime), 0)
INSERT [dbo].[script_record] ([id], [script_id], [db_id], [execute_date], [install_db_id]) VALUES (4, 10, 13, CAST(N'2021-06-04 15:55:30.793' AS DateTime), 0)
INSERT [dbo].[script_record] ([id], [script_id], [db_id], [execute_date], [install_db_id]) VALUES (5, 7, 8, CAST(N'2021-06-04 16:23:20.407' AS DateTime), 0)
INSERT [dbo].[script_record] ([id], [script_id], [db_id], [execute_date], [install_db_id]) VALUES (6, 7, 13, CAST(N'2021-06-04 16:23:20.413' AS DateTime), 0)
INSERT [dbo].[script_record] ([id], [script_id], [db_id], [execute_date], [install_db_id]) VALUES (7, 7, 8, CAST(N'2021-06-04 16:48:26.193' AS DateTime), 0)
INSERT [dbo].[script_record] ([id], [script_id], [db_id], [execute_date], [install_db_id]) VALUES (30, 2, 0, CAST(N'2021-06-09 13:41:32.443' AS DateTime), 1)
INSERT [dbo].[script_record] ([id], [script_id], [db_id], [execute_date], [install_db_id]) VALUES (31, 3, 0, CAST(N'2021-06-09 13:41:32.457' AS DateTime), 1)
INSERT [dbo].[script_record] ([id], [script_id], [db_id], [execute_date], [install_db_id]) VALUES (32, 2, 23, CAST(N'2021-06-09 13:41:33.360' AS DateTime), 0)
INSERT [dbo].[script_record] ([id], [script_id], [db_id], [execute_date], [install_db_id]) VALUES (33, 3, 23, CAST(N'2021-06-09 13:41:33.373' AS DateTime), 0)
INSERT [dbo].[script_record] ([id], [script_id], [db_id], [execute_date], [install_db_id]) VALUES (34, 4, 24, CAST(N'2021-06-09 17:50:56.287' AS DateTime), 0)
INSERT [dbo].[script_record] ([id], [script_id], [db_id], [execute_date], [install_db_id]) VALUES (35, 5, 24, CAST(N'2021-06-09 17:52:49.937' AS DateTime), 0)
INSERT [dbo].[script_record] ([id], [script_id], [db_id], [execute_date], [install_db_id]) VALUES (36, 5, 12, CAST(N'2021-06-09 18:06:21.767' AS DateTime), 0)
INSERT [dbo].[script_record] ([id], [script_id], [db_id], [execute_date], [install_db_id]) VALUES (37, 5, 12, CAST(N'2021-06-09 21:38:19.217' AS DateTime), 0)
INSERT [dbo].[script_record] ([id], [script_id], [db_id], [execute_date], [install_db_id]) VALUES (40, 5, 25, CAST(N'2021-06-10 15:06:57.840' AS DateTime), 0)
INSERT [dbo].[script_record] ([id], [script_id], [db_id], [execute_date], [install_db_id]) VALUES (41, 5, 26, CAST(N'2021-06-10 16:33:48.267' AS DateTime), 0)
INSERT [dbo].[script_record] ([id], [script_id], [db_id], [execute_date], [install_db_id]) VALUES (46, 6, 12, CAST(N'2021-06-17 13:03:14.343' AS DateTime), 0)
INSERT [dbo].[script_record] ([id], [script_id], [db_id], [execute_date], [install_db_id]) VALUES (47, 6, 27, CAST(N'2021-06-17 13:10:42.180' AS DateTime), 0)
INSERT [dbo].[script_record] ([id], [script_id], [db_id], [execute_date], [install_db_id]) VALUES (48, 6, 25, CAST(N'2021-06-17 13:12:05.237' AS DateTime), 0)
INSERT [dbo].[script_record] ([id], [script_id], [db_id], [execute_date], [install_db_id]) VALUES (49, 6, 0, CAST(N'2021-06-17 13:29:17.743' AS DateTime), 1)
INSERT [dbo].[script_record] ([id], [script_id], [db_id], [execute_date], [install_db_id]) VALUES (59, 7, 25, CAST(N'2021-07-05 16:15:45.533' AS DateTime), 0)
INSERT [dbo].[script_record] ([id], [script_id], [db_id], [execute_date], [install_db_id]) VALUES (60, 7, 24, CAST(N'2021-07-05 16:16:01.503' AS DateTime), 0)
INSERT [dbo].[script_record] ([id], [script_id], [db_id], [execute_date], [install_db_id]) VALUES (61, 8, 24, CAST(N'2021-07-05 16:16:26.103' AS DateTime), 0)
INSERT [dbo].[script_record] ([id], [script_id], [db_id], [execute_date], [install_db_id]) VALUES (62, 8, 27, CAST(N'2021-07-05 16:18:16.480' AS DateTime), 0)
INSERT [dbo].[script_record] ([id], [script_id], [db_id], [execute_date], [install_db_id]) VALUES (63, 8, 12, CAST(N'2021-07-05 16:19:24.640' AS DateTime), 0)
INSERT [dbo].[script_record] ([id], [script_id], [db_id], [execute_date], [install_db_id]) VALUES (8, 7, 13, CAST(N'2021-06-04 16:48:26.207' AS DateTime), 0)
INSERT [dbo].[script_record] ([id], [script_id], [db_id], [execute_date], [install_db_id]) VALUES (9, 7, 8, CAST(N'2021-06-04 16:49:54.413' AS DateTime), 0)
INSERT [dbo].[script_record] ([id], [script_id], [db_id], [execute_date], [install_db_id]) VALUES (10, 7, 13, CAST(N'2021-06-04 16:49:54.417' AS DateTime), 0)
INSERT [dbo].[script_record] ([id], [script_id], [db_id], [execute_date], [install_db_id]) VALUES (11, 8, 8, CAST(N'2021-06-04 16:56:18.070' AS DateTime), 0)
INSERT [dbo].[script_record] ([id], [script_id], [db_id], [execute_date], [install_db_id]) VALUES (12, 9, 8, CAST(N'2021-06-04 16:56:18.077' AS DateTime), 0)
INSERT [dbo].[script_record] ([id], [script_id], [db_id], [execute_date], [install_db_id]) VALUES (13, 10, 8, CAST(N'2021-06-04 16:56:18.080' AS DateTime), 0)
INSERT [dbo].[script_record] ([id], [script_id], [db_id], [execute_date], [install_db_id]) VALUES (14, 13, 8, CAST(N'2021-06-04 16:56:18.083' AS DateTime), 0)
INSERT [dbo].[script_record] ([id], [script_id], [db_id], [execute_date], [install_db_id]) VALUES (15, 8, 13, CAST(N'2021-06-04 16:56:18.093' AS DateTime), 0)
INSERT [dbo].[script_record] ([id], [script_id], [db_id], [execute_date], [install_db_id]) VALUES (16, 9, 13, CAST(N'2021-06-04 16:56:18.097' AS DateTime), 0)
INSERT [dbo].[script_record] ([id], [script_id], [db_id], [execute_date], [install_db_id]) VALUES (17, 10, 13, CAST(N'2021-06-04 16:56:18.100' AS DateTime), 0)
INSERT [dbo].[script_record] ([id], [script_id], [db_id], [execute_date], [install_db_id]) VALUES (18, 13, 13, CAST(N'2021-06-04 16:56:18.103' AS DateTime), 0)
INSERT [dbo].[script_record] ([id], [script_id], [db_id], [execute_date], [install_db_id]) VALUES (39, 5, 14, CAST(N'2021-06-10 10:43:18.283' AS DateTime), 0)
INSERT [dbo].[script_record] ([id], [script_id], [db_id], [execute_date], [install_db_id]) VALUES (42, 5, 14, CAST(N'2021-06-16 09:36:45.567' AS DateTime), 0)
INSERT [dbo].[script_record] ([id], [script_id], [db_id], [execute_date], [install_db_id]) VALUES (50, 6, 26, CAST(N'2021-06-17 13:34:56.273' AS DateTime), 0)
INSERT [dbo].[script_record] ([id], [script_id], [db_id], [execute_date], [install_db_id]) VALUES (64, 8, 63, CAST(N'2021-07-07 11:46:18.047' AS DateTime), 0)
INSERT [dbo].[script_record] ([id], [script_id], [db_id], [execute_date], [install_db_id]) VALUES (19, 7, 8, CAST(N'2021-06-04 17:13:28.937' AS DateTime), 0)
INSERT [dbo].[script_record] ([id], [script_id], [db_id], [execute_date], [install_db_id]) VALUES (20, 8, 8, CAST(N'2021-06-04 17:13:28.940' AS DateTime), 0)
INSERT [dbo].[script_record] ([id], [script_id], [db_id], [execute_date], [install_db_id]) VALUES (21, 9, 8, CAST(N'2021-06-04 17:13:28.950' AS DateTime), 0)
INSERT [dbo].[script_record] ([id], [script_id], [db_id], [execute_date], [install_db_id]) VALUES (22, 10, 8, CAST(N'2021-06-04 17:13:28.953' AS DateTime), 0)
INSERT [dbo].[script_record] ([id], [script_id], [db_id], [execute_date], [install_db_id]) VALUES (23, 13, 8, CAST(N'2021-06-04 17:13:28.957' AS DateTime), 0)
INSERT [dbo].[script_record] ([id], [script_id], [db_id], [execute_date], [install_db_id]) VALUES (24, 7, 8, CAST(N'2021-06-04 17:28:21.727' AS DateTime), 0)
INSERT [dbo].[script_record] ([id], [script_id], [db_id], [execute_date], [install_db_id]) VALUES (25, 8, 8, CAST(N'2021-06-04 17:28:21.730' AS DateTime), 0)
INSERT [dbo].[script_record] ([id], [script_id], [db_id], [execute_date], [install_db_id]) VALUES (26, 13, 8, CAST(N'2021-06-04 17:28:21.733' AS DateTime), 0)
INSERT [dbo].[script_record] ([id], [script_id], [db_id], [execute_date], [install_db_id]) VALUES (27, 9, 8, CAST(N'2021-06-04 17:31:52.863' AS DateTime), 0)
INSERT [dbo].[script_record] ([id], [script_id], [db_id], [execute_date], [install_db_id]) VALUES (28, 10, 8, CAST(N'2021-06-04 17:33:22.200' AS DateTime), 0)
INSERT [dbo].[script_record] ([id], [script_id], [db_id], [execute_date], [install_db_id]) VALUES (29, 15, 8, CAST(N'2021-06-04 17:54:33.307' AS DateTime), 0)
INSERT [dbo].[script_record] ([id], [script_id], [db_id], [execute_date], [install_db_id]) VALUES (38, 5, 0, CAST(N'2021-06-09 21:47:45.633' AS DateTime), 1)
INSERT [dbo].[script_record] ([id], [script_id], [db_id], [execute_date], [install_db_id]) VALUES (43, 6, 14, CAST(N'2021-06-17 12:13:12.557' AS DateTime), 0)
INSERT [dbo].[script_record] ([id], [script_id], [db_id], [execute_date], [install_db_id]) VALUES (44, 6, 14, CAST(N'2021-06-17 12:13:40.883' AS DateTime), 0)
INSERT [dbo].[script_record] ([id], [script_id], [db_id], [execute_date], [install_db_id]) VALUES (45, 6, 24, CAST(N'2021-06-17 12:44:18.800' AS DateTime), 0)
INSERT [dbo].[script_record] ([id], [script_id], [db_id], [execute_date], [install_db_id]) VALUES (51, 7, 26, CAST(N'2021-06-24 16:49:56.420' AS DateTime), 0)
INSERT [dbo].[script_record] ([id], [script_id], [db_id], [execute_date], [install_db_id]) VALUES (52, 7, 31, CAST(N'2021-06-24 16:58:57.760' AS DateTime), 0)
INSERT [dbo].[script_record] ([id], [script_id], [db_id], [execute_date], [install_db_id]) VALUES (53, 7, 0, CAST(N'2021-06-24 16:59:17.950' AS DateTime), 1)
INSERT [dbo].[script_record] ([id], [script_id], [db_id], [execute_date], [install_db_id]) VALUES (54, 7, 26, CAST(N'2021-06-24 16:59:56.120' AS DateTime), 0)
INSERT [dbo].[script_record] ([id], [script_id], [db_id], [execute_date], [install_db_id]) VALUES (55, 7, 12, CAST(N'2021-06-24 17:00:19.803' AS DateTime), 0)
INSERT [dbo].[script_record] ([id], [script_id], [db_id], [execute_date], [install_db_id]) VALUES (56, 7, 14, CAST(N'2021-07-04 15:53:01.383' AS DateTime), 0)
INSERT [dbo].[script_record] ([id], [script_id], [db_id], [execute_date], [install_db_id]) VALUES (57, 7, 27, CAST(N'2021-07-04 15:53:43.537' AS DateTime), 0)
INSERT [dbo].[script_record] ([id], [script_id], [db_id], [execute_date], [install_db_id]) VALUES (58, 8, 0, CAST(N'2021-07-05 12:34:28.137' AS DateTime), 1)
SET IDENTITY_INSERT [dbo].[script_record] OFF
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
SET IDENTITY_INSERT [dbo].[web_app] ON 

INSERT [dbo].[web_app] ([id], [name], [description], [location], [db_id], [repo_id], [creator], [create_date], [last_update_date], [url], [deploy], [customize], [removable], [dev]) VALUES (12, N'hanyang', N'韩国hanyang超市', N'D:\html\apphost\hanyang', 12, 1, 1, CAST(N'2021-06-09 12:27:29.023' AS DateTime), CAST(N'2021-07-05 17:33:42.910' AS DateTime), N'hanyang.gcloud.co.nz', 1, 0, 0, 0)
INSERT [dbo].[web_app] ([id], [name], [description], [location], [db_id], [repo_id], [creator], [create_date], [last_update_date], [url], [deploy], [customize], [removable], [dev]) VALUES (14, N'rst374cloud', N'RST374Cloud Demo', N'D:\html\apphost\rst374cloud', 14, 1, 1, CAST(N'2021-06-09 17:24:03.347' AS DateTime), CAST(N'2021-07-02 12:38:19.897' AS DateTime), N'rst374cloud.gpos.nz', 1, 0, 0, 0)
INSERT [dbo].[web_app] ([id], [name], [description], [location], [db_id], [repo_id], [creator], [create_date], [last_update_date], [url], [deploy], [customize], [removable], [dev]) VALUES (34, N'rst374cloud dev', N'rst374cloud开发环境,可在EDIT中改变数据库测试', N'D:\html\webhost\rst374cloud', 14, 1, 1, CAST(N'2021-07-06 10:45:49.463' AS DateTime), NULL, N'rst374clouddev.gpos.nz', 1, 0, 0, 1)
INSERT [dbo].[web_app] ([id], [name], [description], [location], [db_id], [repo_id], [creator], [create_date], [last_update_date], [url], [deploy], [customize], [removable], [dev]) VALUES (13, N'Frescomart', N'Fresco Supermarket', N'D:\html\apphost\Frescomart', 24, 1, 1, CAST(N'2021-06-09 15:38:12.057' AS DateTime), CAST(N'2021-06-17 12:43:54.613' AS DateTime), N'fresco.gcloud.co.nz', 1, 0, 0, 0)
INSERT [dbo].[web_app] ([id], [name], [description], [location], [db_id], [repo_id], [creator], [create_date], [last_update_date], [url], [deploy], [customize], [removable], [dev]) VALUES (16, N'wistle', N'wistle mreport(activata)', N'', 26, 0, 1, CAST(N'2021-06-10 15:34:23.867' AS DateTime), NULL, NULL, 0, 0, 0, 0)
INSERT [dbo].[web_app] ([id], [name], [description], [location], [db_id], [repo_id], [creator], [create_date], [last_update_date], [url], [deploy], [customize], [removable], [dev]) VALUES (17, N'Giantd', N'Giantd 印度两元三元店', N'D:\html\apphost\Giantd', 25, 1, 1, CAST(N'2021-06-10 15:43:22.010' AS DateTime), CAST(N'2021-07-02 12:29:46.963' AS DateTime), N'giantd.gcloud.co.nz', 1, 0, 0, 0)
INSERT [dbo].[web_app] ([id], [name], [description], [location], [db_id], [repo_id], [creator], [create_date], [last_update_date], [url], [deploy], [customize], [removable], [dev]) VALUES (22, N'南顺发Glenfiled', N'南顺发Glenfiled ', N'D:\html\apphost\pxb', 27, 1, 1, CAST(N'2021-06-11 14:41:19.043' AS DateTime), CAST(N'2021-07-02 12:28:59.133' AS DateTime), N'pxb.gcloud.co.nz', 1, 0, 0, 0)
SET IDENTITY_INSERT [dbo].[web_app] OFF
USE [master]
GO
ALTER DATABASE [app_host] SET  READ_WRITE 
GO
