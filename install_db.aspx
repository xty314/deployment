<%@ Page Language="C#" AutoEventWireup="true" CodeFile="install_db.aspx.cs" Inherits="install_db" MasterPageFile="./master/_layout.master" %>



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
                    <h1>Installation BD</h1>
                </div>
                <div class="col-sm-6">
                    <div class="float-right">
                        <button class="btn bg-blue" data-toggle="modal" data-target="#NewModal">
                            <i
                                class="fa fa-pen"></i>Add New Database</button>
                        <%--<button class="btn bg-blue" data-toggle="modal" data-target="#NewCompanyModal"><i
                                class="fa fa-pen"></i>Update </button>--%>
                        <%-- <button type="button" class="btn btn-success"><i class="fa fa-download"></i>Export </button>--%>
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
        <form method="post">
        <div class="card">

            <div class="card-body p-0" style="display: block;">
                <table class="table table-striped table-hover projects">
                    <thead>
                        <tr>
                            <th style="width: 1%">#id
                            </th>
                            <th style="width: 15%">DB Name
                            </th>
                            <th>Description
                            </th>
                            <th class="text-center">Created Date
                            </th>
                            <th class="text-center">Last Update Date
                            </th>
                            <th class="text-right">Action
                            </th>
                        </tr>
                    </thead>
                    <tbody>
                        <%foreach (DataRow dr in dbDataTable.Rows)
                            {%>
                        <tr>
                            <td>#<%=dr["id"]%>
                            </td>
                            <td>
                                <a>
                                    <%=dr["name"] %>
                                </a>

                            </td>
                            <td>
                                <%=dr["description"] %>
                            </td>
                            <td class="project_progress  text-center">
                                <%=dr["create_date"] %>              
                            </td>
                               <td class="project_progress  text-center">
                                <%=dr["last_update_date"] %>              
                            </td>
                            <td class="project-actions text-right">
                                   <a class="btn  bg-navy btn-sm edit-btn ml-1 mb-1" href="script.aspx?origin=<%=dr["id"] %>">
                                    <i class="fas fa-history"></i>
                                       Script History
                                </a>

                                <button class="btn btn-warning btn-sm backup-btn ml-1 mb-1"  name="backup" value="<%=dr["id"] %>">
                                    <i class="fas fa-plus-circle"></i>
                                    Update Bak
                                </button>
                                <a class="btn bg-indigo btn-sm script-btn ml-1 mb-1" href="#"
                                    data-toggle="modal" data-target="#ScriptModal"
                                    data-id='<%=dr["id"]%>' data-install=true
                                   
                                    >
                                    <i class="fas fa-caret-square-right"></i> 
                                    Run Script
                                </a>
                             
                                <a class="btn btn-info btn-sm edit-btn ml-1 mb-1" href="#"
                                    data-toggle="modal" data-target="#EditModal"
                                    data-id='<%=dr["id"]%>'
                                    data-name="<%=dr["name"] %>"
                                    data-location="<%=dr["location"] %>"
                                      data-description="<%=dr["description"] %>"
                                    data-database="<%=Common.GetDatabase(dr["conn_str"].ToString()) %>"
                                    data-server="<%=Common.GetServer(dr["conn_str"].ToString()) %>">
                                    <i class="fas fa-pencil-alt"></i>
                                    EDIT
                                </a>
                                <%if ((bool)dr["removable"])
                                    { %>
                                <a class="btn btn-danger btn-sm delete-btn ml-1 mb-1" href="#"
                                    data-toggle="modal" data-target="#DeleteModal"
                                    data-company="<%=dr["name"] %>"
                                    data-id='<%=dr["id"]%>'>
                                    <i class="fas fa-trash"></i>
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
        </form>
        <!-- /.card -->

    </section>
    <form method="post" id='NewForm'>
        <div class="modal fade" id="NewModal" tabindex="-1" role="dialog"
            aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="exampleModalLabel">New Install DB</h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body">

                        <div class="form-group row">
                            <label for="recipient-name" class="col-form-label col-sm-4">DB Name:</label>
                            <input type="text" class="form-control  col-sm-8" name='dbname'>
                        </div>
                        <div class="form-group row">
                            <label for="recipient-name" class="col-form-label col-sm-4">DB Server:</label>
                            <input type="text" class="form-control  col-sm-8" name='server' value="<%= Common.GetSetting("db_server")%>" />
                        </div>
                        <div class="form-group row">
                            <label for="recipient-name" class="col-form-label col-sm-4" data-toggle="tooltip" title="bak文件在数据库服务器的路径">.bak File Location:</label>
                            <input type="text" class="form-control  col-sm-8" name='location' value="<%= Common.GetSetting("install_db_location")%>" />
                        </div>
                        <div class="form-group row">
                            <label class="col-form-label col-sm-4">Description</label>
                            <textarea class="form-control col-sm-8" rows="3" name="description" placeholder="Description ..." style="margin-top: 0px; margin-bottom: 0px; height: 105px;"></textarea>
                        </div>
                        <%-- <input type="hidden" class="form-control  col-sm-10" name='company' id="s_new_sscat">--%>
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
            <div class="modal-dialog modal-lg" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Eidt Install DB</h5>
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
                 <div class="form-group row">
                            <label for="recipient-name" class="col-form-label col-sm-4">Location:</label>
                            <input type="text" class="form-control  col-sm-8" name='location' />
                        </div>
                        <div class="form-group row">
                            <label for="recipient-name" class="col-form-label col-sm-4">Database:</label>
                            <input type="text" class="form-control  col-sm-8" name='database' disabled/>
                        </div>
                        <div class="form-group row">
                            <label for="recipient-name" class="col-form-label col-sm-4">Server:</label>
                            <input type="text" class="form-control  col-sm-8" name='server' disabled/>
                        </div>
                     <div class="form-group row">
                            <label class="col-form-label col-sm-4">Description</label>
                            <textarea class="form-control col-sm-8" rows="3" name="description"  style="margin-top: 0px; margin-bottom: 0px; height: 105px;"></textarea>
                        </div>
             <%--           <div class="form-group row">
                            <label class="col-form-label col-sm-4" for="removableCheck">Removable</label>
                            <input type="checkbox" class="form-control form-control-sm col-sm-1" name="removable" id="removableCheck" value="1" />

                        </div>--%>

                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                        <button type="submit" name='cmd' value='edit' class="btn btn-primary">Save</button>
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
                        <h5 class="modal-title">Delete Company</h5>
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
                            <input type="checkbox" class="form-check-input form-check-input-lg" name="deleteDb" id="deleteDbCheck" value="1">
                            <label class="form-check-label" for="deleteDbCheck">delete database.</label>
                        </div>
                        <div class="form-check">
                            <input type="checkbox" class="form-check-input form-check-input-lg" name="backup" id="backupCheck" value="1" checked>
                            <label class="form-check-label" for="backupCheck">back up database.</label>
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
        <form method="post" action="execute.aspx" id='ScriptForm'>
        <div class="modal fade" id="ScriptModal" tabindex="-1" role="dialog"
            aria-hidden="true">
            <div class="modal-dialog modal-lg" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Run Script</h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body">
                        <input type="hidden" class="form-control  col-sm-8" name='id' />
               
                
                        <div class="form-group row">
                            <label for="editDatabase" class="col-form-label col-sm-4" id="scriptLabel">Script:</label>

                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                        <button type="submit" name='cmd' value='install' class="btn btn-primary">Save</button>
                    </div>
                </div>
            </div>
        </div>
    </form>
    <!-- /.content -->
</asp:Content>
<asp:Content ContentPlaceHolderID="AdditionalJS" runat="server">
    <script src="src/js/install_db.js"></script>

</asp:Content>
