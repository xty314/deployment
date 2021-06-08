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
                <div class="col-sm-6">
                    <h1>Web App</h1>
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
                <table class="table table-striped table-hover projects">
                    <thead>
                        <tr>
                            <th style="width: 1%">#id
                            </th>
                            <th>App Name
                            </th>

                            <th>Description
                            </th>
                            <th>Url
                            </th>
                            <th>Database
                            </th>
                            <th>Api
                            </th>
                            <th class="text-center">Last Update Date
                            </th>
                            <th style="width: 35%" class="text-right">Action
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

                                <%=dr["name"] %><br />
                                <small><%=dr["location"] %></small>

                            </td>
                            <td>
                                <%=dr["description"] %>
                            </td>
                            <td>
                                <%=dr["url"] %>
                            </td>
                            <td>
                                <%=dr["db_name"] %>
                            </td>
                            <td>
                                <%=string.Format(Common.GetSetting("cloud_sync_api"),dr["db_id"]) %>

                            </td>
                            <td>
                                <%=dr["last_update_date"] %>            
                            </td>

                            <td class="project-actions text-right">


                                <a class="btn btn-warning btn-sm edit-btn" href="#">
                                    <i class="fas fa-plus-circle"></i>Update
                                </a>
                                <a class="btn btn-danger btn-sm edit-btn" href="#">
                                    <i class="fas fa-history"></i>Customize Check
                                </a>

                                 <%--deploy button or unbind button--%>
                                <%if (dr["deploy"].ToString().ToLower() == "false")
                                    { %>
                                <a class="btn btn-primary btn-sm deploy-btn"
                                    data-toggle="modal" data-target="#DeployModal"
                                    data-id="<%=dr["id"] %>">
                                    <i class="fas fa-upload"></i>Deploy
                                </a><%}
                                        else
                                        { %>
                                <a class="btn bg-indigo btn-sm unbind-btn" href="#"
                                    data-toggle="modal" data-target="#UnbindModal" data-id='<%=dr["id"]%>'>
                                    <i class="fas fa-link"></i>
                                    Unbind IIS
                                </a>
                                <%} %>
                                 <%--eidt button--%>
                                <a class="btn btn-info btn-sm edit-btn" href="#"
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

                                <%--delete button--%>
                                 <%if ((bool)dr["removable"]){ %>
                                  <a class="btn btn-danger btn-sm delete-btn" href="#" 
                                        data-toggle="modal" data-target="#DeleteModal"
                                        data-name='<%=dr["name"]%>'
                                       data-id='<%=dr["id"]%>'
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
                            <input type="text" class="form-control  col-sm-8" name='url'/>
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
                            <input type="checkbox" class="form-check-input form-check-input-lg" name="deleteFile" id="backupCheck" value="1" checked>
                            <label class="form-check-label" for="backupCheck">Delete the directory <span id="deleteFileLocation">E:\\webhost\\royal</span></label>
                        </div>

                    </div>

                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                        <button type="submit" name='cmd' value="delete" class="btn btn-primary" id="DeleteModalBtn">Delete</button>
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
