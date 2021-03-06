/*

Copyright (c) 2008-2014 by the President and Fellows of Harvard College. All rights reserved.  Profiles Research Networking Software was developed under the supervision of Griffin M Weber, MD, PhD., and Harvard Catalyst: The Harvard Clinical and Translational Science Center, with support from the National Center for Research Resources and Harvard University.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
    * Neither the name "Harvard" nor the names of its contributors nor the name "Harvard Catalyst" may be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDER (PRESIDENT AND FELLOWS OF HARVARD COLLEGE) AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


*/
/*
** Assumes Default Location of the SQL Server Data and Log files
*/
if exists (select * from sysdatabases where [name] = 'ProfilesRNS')
begin
	DROP DATABASE [ProfilesRNS]
end
go
CREATE DATABASE [ProfilesRNS]
GO
ALTER DATABASE [ProfilesRNS] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [ProfilesRNS] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [ProfilesRNS] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [ProfilesRNS] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [ProfilesRNS] SET ARITHABORT OFF 
GO
ALTER DATABASE [ProfilesRNS] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [ProfilesRNS] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [ProfilesRNS] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [ProfilesRNS] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [ProfilesRNS] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [ProfilesRNS] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [ProfilesRNS] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [ProfilesRNS] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [ProfilesRNS] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [ProfilesRNS] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [ProfilesRNS] SET  DISABLE_BROKER 
GO
ALTER DATABASE [ProfilesRNS] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [ProfilesRNS] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [ProfilesRNS] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [ProfilesRNS] SET  READ_WRITE 
GO
ALTER DATABASE [ProfilesRNS] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [ProfilesRNS] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
GO
ALTER DATABASE [ProfilesRNS] SET ALLOW_SNAPSHOT_ISOLATION ON
GO
ALTER DATABASE [ProfilesRNS] SET READ_COMMITTED_SNAPSHOT ON 
GO
SET TRANSACTION ISOLATION LEVEL SNAPSHOT
GO
ALTER DATABASE [ProfilesRNS] set MULTI_USER;
GO
ALTER DATABASE [ProfilesRNS] set RECOVERY SIMPLE

USE [ProfilesRNS]
GO
IF NOT EXISTS (SELECT name FROM sys.filegroups WHERE is_default=1 AND name = N'PRIMARY') ALTER DATABASE [ProfilesRNS] MODIFY FILEGROUP [PRIMARY] DEFAULT
GO
