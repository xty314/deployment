<%@ Control Language="C#" AutoEventWireup="true" CodeFile="LeftSidebar.ascx.cs" Inherits="Master_Page_LeftSidebar" %>

<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>




<aside class="main-sidebar sidebar-dark-primary elevation-4">
    <!-- Brand Logo -->
  <%--  <a href="index.aspx" class="brand-link">
        <img src="dist/img/AdminLTELogo.png" alt="AdminLTE Logo" class="brand-image img-circle elevation-3" style="opacity: .8">
        <span class="brand-text font-weight-light">GPOS</span>
    </a>--%>

    <!-- Sidebar -->
    <div class="sidebar">
        <!-- Sidebar user panel (optional) -->
        <div class="user-panel mt-3 pb-3 mb-3 d-flex">
            <div class="image">
                <%--<img src="dist/img/user2-160x160.jpg" class="img-circle elevation-2" alt="User Image">--%>
            </div>
            <div class="info">
                <a href="index.aspx" class="d-block">SETUP</a>
            </div>
        </div>

        <!-- SidebarSearch Form -->
<%--        <div class="form-inline">
            <div class="input-group" data-widget="sidebar-search">
                <input class="form-control form-control-sidebar" type="search" placeholder="Search" aria-label="Search">
                <div class="input-group-append">
                    <button class="btn btn-sidebar">
                        <i class="fas fa-search fa-fw"></i>
                    </button>
                </div>
            </div>
        </div>--%>

        <!-- Sidebar Menu -->
        <nav class="mt-2">
            <ul class="nav nav-pills nav-sidebar flex-column nav-child-indent" data-widget="treeview" role="menu" data-accordion="false">
                <!-- Add icons to the links using the .nav-icon class
                 with font-awesome or any other icon font library -->
                <li class="nav-item  menu-is-opening menu-open" >
                    <a href="#" class="nav-link">
                        <i class="nav-icon fas fa-database"></i>
                        <p>
                            Database
                 
                            <i class="right fas fa-angle-left"></i>
                        </p>
                    </a>
                    <ul class="nav nav-treeview">
                               <li class="nav-item">
                            <a href="/database.aspx" class="nav-link ">
                                <i class="far fa-circle nav-icon"></i>
                                <p>Database List</p>
                            </a>
                        </li>
                          <li class="nav-item">
                            <a href="/install_db.aspx" class="nav-link">
                                <i class="far fa-circle nav-icon"></i>
                                <p>Install DB</p>
                            </a>
                        </li>
                 
                        <li class="nav-item">
                            <a href="/script.aspx" class="nav-link">
                                <i class="far fa-circle nav-icon"></i>
                                <p>Script</p>
                            </a>
                        </li>
                    </ul>
                </li>
                <li class="nav-item  menu-is-opening menu-open">
                    <a href="#" class="nav-link">
                        <i class="nav-icon fab fa-chrome"></i>
                        <p>
                           Web App
                            <i class="right fas fa-angle-left"></i>
                        </p>
                    </a>
                    <ul class="nav nav-treeview">
                         <li class="nav-item">
                            <a href="app_list.aspx" class="nav-link">
                                <i class="far fa-circle nav-icon"></i>
                                <p>App</p>
                            </a>
                        </li>
                        <li class="nav-item">
                            <a href="repository.aspx" class="nav-link ">
                                <i class="far fa-circle nav-icon"></i>
                                <p>Repository</p>
                            </a>
                        </li>
                          <li class="nav-item">
                            <a href="mreport.aspx" class="nav-link ">
                                <i class="far fa-circle nav-icon"></i>
                                <p>Mreport</p>
                            </a>
                        </li>
                       
                    </ul>
                </li>
          <li class="nav-item  menu-is-opening menu-open">
                    <a href="#" class="nav-link">
                        <i class="nav-icon far fa-file-code"></i>
                        <p>
                          Development
                            <i class="right fas fa-angle-left"></i>
                        </p>
                    </a>
                    <ul class="nav nav-treeview">
                         <li class="nav-item">
                            <a href="dev_app.aspx" class="nav-link">
                                <i class="far fa-circle nav-icon"></i>
                                <p>Dev App</p>
                            </a>
                        </li>
                        <li class="nav-item">
                            <a href="dev_db.aspx" class="nav-link ">
                                <i class="far fa-circle nav-icon"></i>
                                <p>Dev Database</p>
                            </a>
                        </li>
                    
                       
                    </ul>
                </li>
                <li class="nav-item">
                    <a href="setting.aspx" class="nav-link">
                        <i class="nav-icon fas fa-th"></i>
                        <p>
                            Setting
                 
                            <%--<span class="right badge badge-danger">New</span>--%>
                        </p>
                    </a>
                </li>
    
    
         
  
          
        

            </ul>
        </nav>
        <!-- /.sidebar-menu -->
    </div>
    <!-- /.sidebar -->
</aside>
