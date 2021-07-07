<%@ Page Language="C#" AutoEventWireup="true" CodeFile="app_list.aspx.cs" Inherits="app_list" MasterPageFile="./master/_layout.master" %>


<%--import MasterPageFile--%>


<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Data" %>
<asp:Content ContentPlaceHolderID="AdditionalCSS" runat="server">
</asp:Content>

<asp:Content ContentPlaceHolderID="Header" runat="server">
    <section class="content-header">
        <div class="container-fluid">
            <div class="row mb-2">
                <div class="col-sm-6 row">
                    <h1 class="mr-5">Web App</h1>
                    <%=PrintRepoListHeader() %>
                </div>
                <div class="col-sm-6">
                    <div class="float-right">
                        <button class="btn bg-blue" data-toggle="modal" data-target="#NewModal">
                            <i
                                class="fa fa-pen"></i>Add New App</button>
                 
                    </div>
                </div>
            </div>
        </div>
        <!-- /.container-fluid -->
    </section>


</asp:Content>
<asp:Content ContentPlaceHolderID="Content" runat="server">

    <!-- Main content -->
    <section class="content">
        <%if (!String.IsNullOrEmpty(info))
            { %>
        <div class="col-lg-12">
            <div class="callout callout-danger">
                <h5><%=info %></h5>

            </div>
        </div>
        <%} %>
        <!-- Default box -->
        <div class="card">
         
            <div class="card-body p-0" style="display: block;">
                <table 
                    class="table table-striped table-hover"
                      id="table"
              data-toggle="table"
                     data-search="true"
                      data-sortable="true"
                      
                     >
                    <thead>
                        <tr>
                            <th data-field="id" data-sortable="true" style="width: 1%">#id
                            </th>
                            <th data-field="name" data-sortable="true"  style="width: 4%">App Name
                            </th>

                            <th style="width: 10%">Description
                            </th>
                         
                            <th style="width: 10%">Database
                            </th>
                            <th style="width: 30%">URL
                            </th>
                                 <th style="width: 10%">IIS State
                            </th>
                            <th   data-field="last_update_date" data-sortable="true"  style="width: 15%">Last Update Date
                            </th>
                            <th style="width: 40%" class="text-right">Action
                            </th>
                        </tr>
                    </thead>
                    <tbody>
                        <%foreach (DataRow dr in appDataTable.Rows)
                            {%>
                        <tr>
                            <td>#<%=dr["id"]%>
                            </td>
                            <td>

                                   <a href="http://<%=dr["url"] %>" target="_blank">
                                <%=dr["name"] %></a><br />
                                <small><%=dr["location"] %></small>

                            </td>
                            <td>
                                <%=dr["description"] %>
                            </td>
                
                            <td>
                               <a href="database.aspx?id=<%=dr["db_id"] %>"><%=dr["db_name"] %></a> <br />
                                 <small><%=Common.GetServer(dr["conn_str"].ToString()) %></small>
                            </td>
                            <td> 
                                <%if ((bool)dr["deploy"])
                                     { %>
                               <small>Cloud URL: <a href="http://<%=dr["url"] %>">http://<%=dr["url"] %></a>
                                    <button type="button" class="btn btn-default btn-sm copy-btn"><i class="far fa-copy"></i> Copy</button>
                               </small><br />
                                <%} %>
                               <small> SYNC API: <span><%=string.Format(Common.GetSetting("cloud_sync_api"),dr["id"]) %></span> 
                                   <button type="button" class="btn btn-default btn-sm copy-btn"><i class="far fa-copy"></i> Copy</button>
                               </small><br />
                                   <%if (!string.IsNullOrEmpty(dr["mreport_url"].ToString()))
                                     { %>
                               <small>Mreport: <a href="<%=dr["mreport_url"] %>" target="_blank"><%=dr["mreport_url"] %></a>
                                    <button type="button" class="btn btn-default btn-sm copy-btn"><i class="far fa-copy"></i> Copy</button>
                               </small><br />
                                <%} %>

                            </td>
                               <td>
                                <%string iisState=GetiisState(dr["id"].ToString()); %>  
                                 <%if (!string.IsNullOrEmpty(iisState)){ %>
                                   <%=iisState %><br />

                                    <a class="btn bg-lightblue btn-sm restart-btn ml-1 mb-1" href="#"
                                    data-toggle="modal" data-target="#RestartModal" data-id='<%=dr["id"]%>'>
                                    <i class="fas fa-sync-alt"></i>
                                    <%if(iisState=="Started"){ %>
                                    Stop IIS
                                        <%}else{ %>
                                        Start IIS
                                        <%} %>
                                </a>
                                 <%}%>
                                   
                            </td>
                            <td>
                                <%=dr["last_update_date"] %>            
                            </td>

                            <td class="project-actions text-right">
                                <div class="btn-group ml-1 mb-1">
                                <button type="button" class="btn btn-primary  btn-sm dropdown-toggle dropdown-icon" data-toggle="dropdown">
                                    Action
                                </button>
                                <div class="dropdown-menu" role="menu">
                                    <a class="dropdown-item" href="./app_user.aspx?id=<%=dr["id"]%>"><i class="fas fa-user"></i>USER</a>
                                    <div class="dropdown-divider"></div>
                                        <a class="dropdown-item" href="./app_branch.aspx?id=<%=dr["id"]%>"><i class="fas fa-building"></i>BRANCH</a>
                                    </div>
                                </div>

                              <%if((int)dr["repo_id"]>0){ %>
                                <a class="btn btn-warning btn-sm pull-btn ml-1 mb-1" href="#"
                                   data-toggle="modal" data-target="#PullModal"
                                    data-id="<%=dr["id"] %>""
                                   >
                                    <i class="fas fa-plus-circle"></i>
                                    Update
                                </a>
                                <a class="btn btn-danger btn-sm edit-btn ml-1 mb-1" href="?check=<%=dr["id"] %>">
                                    <i class="fas fa-history"></i>
                                    Modify Check
                                </a>
                                 
                                <%if (dr["deploy"].ToString().ToLower() == "false")
                                    { %>
                                <a class="btn btn-primary btn-sm deploy-btn ml-1 mb-1"
                                    data-toggle="modal" data-target="#DeployModal"
                                    data-id="<%=dr["id"] %>">
                                    <i class="fas fa-upload"></i>
                                    Deploy
                                </a><%}
                                else
                                { %>
                                <a class="btn bg-indigo btn-sm unbind-btn ml-1 mb-1" href="#"
                                    data-toggle="modal" data-target="#UnbindModal" data-id='<%=dr["id"]%>'>
                                    <i class="fas fa-link"></i>
                                    Unbind IIS
                                </a>
                            
                                <%} } %>
                                <a class="btn btn-info btn-sm edit-btn ml-1 mb-1" href="#"
                                    data-toggle="modal" data-target="#EditModal"
                                    data-id='<%=dr["id"]%>'
                                    data-name="<%=dr["name"] %>"
                                      data-description="<%=dr["description"] %>"
                                      data-db="<%=dr["db_id"] %>"
                                     data-removable="<%=dr["removable"] %>"
                                    >
                                    <i class="fas fa-pencil-alt"></i>
                                    EDIT
                                </a>

                         
                                 <%if ((bool)dr["removable"]){ %>
                                  <a class="btn btn-danger btn-sm delete-btn ml-1 mb-1" href="#" 
                                        data-toggle="modal" data-target="#DeleteModal"
                                        data-name='<%=dr["name"]%>'
                                       data-id='<%=dr["id"]%>'
                                      data-repo='<%=dr["repo_id"]%>'
                                       data-location='<%=dr["location"]%>'
                                      >
                                    <i class="fas fa-trash">
                                    </i>
                                   DELETE
                                </a>
                                <%} %>
                            </td>
                        </tr>
                        <%} %>
                    </tbody>
                </table>
            </div>
            <!-- /.card-body -->
        </div>
        <!-- /.card -->

    </section>
    <form method="post" id='NewForm'>
        <div class="modal fade" id="NewModal" tabindex="-1" role="dialog"
            aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="exampleModalLabel">New App</h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body">
                         <div class="form-group row">
                            <label for="recipient-name" class="col-form-label col-sm-4">Directory:</label>
                            <input type="text" class="form-control  col-sm-8" name='location' value="<%=Common.GetSetting("app_install_location") %>">
                        </div>
                        <div class="form-group row">
                            <label for="recipient-name" class="col-form-label col-sm-4">Name:</label>
                            <input type="text" class="form-control  col-sm-8" name='name'>
                        </div>
                        <%=PrintRepoList()%>
                        <%= PrintDbList()%>
                        <div class="form-group row">
                            <label class="col-form-label col-sm-4">Description</label>
                            <textarea class="form-control col-sm-8" rows="3" name="description" placeholder="Description ..." style="margin-top: 0px; margin-bottom: 0px; height: 105px;"></textarea>
                        </div>
                        <div class="form-group row private_info">
                            <label for="recipient-name" class="col-form-label col-sm-4">Git User Name:</label>
                            <input type="text" class="form-control  col-sm-8" name='gitname'>
                        </div>
                        <div class="form-group row private_info">
                            <label for="recipient-name" class="col-form-label col-sm-4">Git Password:</label>
                            <input type="password" class="form-control  col-sm-8" name='gitpass' />
                        </div>
                       <div class="form-group row"">
                             <label class="col-form-label col-sm-4" for="newMeportCheck">Create Mreport:</label>
                            <input type="checkbox" class="form-control form-control-sm col-sm-1" name="createMreport" id="newMeportCheck" value=1>
 
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                        <button type="submit" name='cmd' value='new' class="btn btn-primary">Save</button>
                    </div>
                </div>
            </div>
        </div>
    </form>
    <form method="post" id='EditForm'>
        <div class="modal fade" id="EditModal" tabindex="-1" role="dialog"
            aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Eidt App Info</h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body">
                        <input type="hidden" class="form-control  col-sm-8" name='id' />
           
                        <div class="form-group row">
                            <label for="recipient-name" class="col-form-label col-sm-4">Name:</label>
                            <input type="text" class="form-control  col-sm-8" name='name'>
                        </div>

                        <%= PrintDbList()%>
                        <div class="form-group row">
                            <label class="col-form-label col-sm-4">Description</label>
                            <textarea class="form-control col-sm-8" rows="3" name="description" placeholder="Description ..." style="margin-top: 0px; margin-bottom: 0px; height: 105px;"></textarea>
                        </div>
                          <div class="form-group row"">
                             <label class="col-form-label col-sm-4" for="removableCheck">Removable</label>
                            <input type="checkbox" class="form-control form-control-sm col-sm-1" name="removable" id="removableCheck" value=1>
                           
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                        <button type="submit" name='cmd' value='edit' class="btn btn-primary">Save</button>
                    </div>
                </div>
            </div>
        </div>
    </form>
    <form method="post" id='DeployForm'>
        <div class="modal fade" id="DeployModal" tabindex="-1" role="dialog"
            aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">IIS Deployment</h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body">
                        <input type="hidden" class="form-control  col-sm-8" name='id' value="1" />
                        <h5>Setup IIS with the following domain name, protocol would be [http] and port is [80] </h5>
                          <h5>url example: test.gpos.nz,   aaa.com </h5>
                        <div class="form-group row">
                            <label for="recipient-name" class="col-form-label col-sm-4">URL:</label>
                         <div class="input-group col-sm-8">
                  <div class="input-group-prepend">
                    <span class="input-group-text">http://</span>
                  </div>
                 <input type="text" class="form-control  " name='url'/>
                </div>
                            
                        </div>


                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                            <button type="submit" name='cmd' value='deploy' class="btn btn-primary">Deploy</button>
                        </div>
                    </div>
                </div>
            </div>
    </div>
    </form>
       <form method="post" id='RestartForm'>
        <div class="modal fade" id="RestartModal" tabindex="-1" role="dialog"
            aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content bg-lightblue">
                    <div class="modal-header">
                        <h5 class="modal-title">IIS</h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body" >
                        <input type="hidden" class="form-control  col-sm-8" name='id' />
                        <h5>Are you sure to operate IIS?</h5>
                    </div>

                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                        <button type="submit" name='cmd' value="restart" class="btn btn-info" >Comfirm</button>
                    </div>
                </div>
            </div>
        </div>
    </form>
 <form method="post" id='UnbindForm'>
        <div class="modal fade" id="UnbindModal" tabindex="-1" role="dialog"
            aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content bg-danger">
                    <div class="modal-header">
                        <h5 class="modal-title">Unbind IIS</h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body" >
                        <input type="hidden" class="form-control  col-sm-8" name='id' />
                        <h5>Are you sure to unbind this site from IIS?</h5>
                    </div>

                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                        <button type="submit" name='cmd' value="idle" class="btn btn-warning" >Comfirm</button>
                    </div>
                </div>
            </div>
        </div>
    </form>
    <form method="post" id='DeleteForm'>
        <div class="modal fade" id="DeleteModal" tabindex="-1" role="dialog"
            aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content bg-danger">
                    <div class="modal-header">
                        <h5 class="modal-title">Delete App</h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body" id="DeleteModalBody">
                        <input type="hidden" class="form-control  col-sm-8" name='id' />
                      
                        <h5 id="deletePrompt"></h5>
                        <div class="form-group row">
                            <label for="recipient-name" class="col-form-label col-sm-4">Password:</label>
                            <input type="password" class="form-control  col-sm-8" name='password'>
                        </div>
                
                        <div class="form-check">
                            <input type="checkbox" class="form-check-input form-check-input-lg" name="deleteFile" id="deleteCheck" value="1" checked>
                            <label class="form-check-label" for="deleteCheck">Delete the directory <span id="deleteFileLocation"></span></label>
                        </div>

                    </div>

                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary " data-dismiss="modal">Close</button>
                        <button type="submit" name='cmd' value="delete" class="btn btn-primary once-click-btn" id="DeleteModalBtn">Delete</button>
                    </div>
                </div>
            </div>
        </div>
    </form>
     <form method="post" id='PullForm'>
        <div class="modal fade" id="PullModal" tabindex="-1" role="dialog"
            aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" >Update App</h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body">
                       <input type="hidden" class="form-control  col-sm-8" name='id' />
                        <div class="form-group row private_info">
                            <label for="recipient-name" class="col-form-label col-sm-4">Git User Name:</label>
                            <input type="text" class="form-control  col-sm-8" name='gitname'>
                        </div>
                        <div class="form-group row private_info">
                            <label for="recipient-name" class="col-form-label col-sm-4">Git Password:</label>
                            <input type="password" class="form-control  col-sm-8" name='gitpass' />
                        </div>
               
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                        <button type="submit" name='cmd' value='pull' class="btn btn-primary">Update</button>
                    </div>
                </div>
            </div>
        </div>
    </form>
    <!-- /.content -->
</asp:Content>
<asp:Content ContentPlaceHolderID="AdditionalJS" runat="server">
    <script src="src/js/app_list.js"></script>
</asp:Content>
