<%@ Page Language="C#" AutoEventWireup="true" CodeFile="database.aspx.cs" Inherits="database" MasterPageFile="./master/_layout.master" %>


<%--import MasterPageFile--%>


<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Data" %>


<asp:Content ContentPlaceHolderID="Header" runat="server">
    <section class="content-header">
        <div class="container-fluid">
            <div class="row mb-2">
                <div class="col-sm-6 row">
                    <h1 class="mr-5">Database</h1>
                    <%=PrintInstallDbListHeader() %>
                </div>
                <div class="col-sm-6">
                    <div class="float-right">
                        <button class="btn bg-blue" data-toggle="modal" data-target="#NewModal">
                            <i
                                class="fa fa-pen"></i>Add New Database</button>
                        <%if (!string.IsNullOrEmpty(Request.QueryString["origin"]) && Request.QueryString["origin"] != "0")
                            {%>
                        <button class="btn bg-indigo" data-toggle="modal" data-target="#ScriptModal">
                            <i
                                class="fa fa-book"></i>
                            Bulk Run Script
                        </button>
                        <%} %>
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
        <form method="post">
        <!-- Default box -->
        <div class="card">

            <div class="card-body p-0" style="display: block;">
                <table class="table table-striped table-hover projects">
                    <thead>
                        <tr>
                            <%if (!string.IsNullOrEmpty(Request.QueryString["origin"]) && Request.QueryString["origin"] != "0")
                                {%>
                            <th style="width: 1%">
                                  <div class="icheck-primary">
                                    <input type="checkbox" id="dbCBXAll"  name="db_id" />
                                    <label for="dbCBXAll"></label>
                                </div>
                            </th>
                            <%} %>

                            <th style="width: 1%">#id
                            </th>
                            <th>Name
                            </th>
                            <th>Database
                            </th>
                            <th>Server
                            </th>
                            <th>Origin
                            </th>
                            <th>Create Date
                            </th>
                             <th>Update Date
                            </th>
                            <th class="text-right">Action
                            </th>
                        </tr>
                    </thead>
                    <tbody>
                        <%foreach (DataRow dr in dbDataTable.Rows)
                            {%>
                        <tr>
                            <%if (!string.IsNullOrEmpty(Request.QueryString["origin"]) && Request.QueryString["origin"] != "0")
                                {%>
                            <td>
                                <div class="icheck-primary">
                                    <input type="checkbox" id="dbCBX<%=dr["id"]%>" value="<%=dr["id"]%>" name="db_id" />
                                    <label for="dbCBX<%=dr["id"]%>"></label>
                                </div>

                            </td>
                            <%} %>

                            <td>#<%=dr["id"]%>
                            </td>
                            <td>
                                <%=dr["name"] %>
                            </td>
                            <td>
                                <%=Common.GetDatabase(dr["conn_str"].ToString()) %>
                            </td>
                            <td>
                                <%=Common.GetServer(dr["conn_str"].ToString()) %>
                            </td>
                            <td>
                                <%=dr["install_db_name"] %>
                            </td>
                            <td>
                                <%=dr["create_date"] %>         
                            </td>
                             <td>
                                <%=dr["update_date"] %>         
                            </td>
                            <td class="project-actions text-right">
                                <a class="btn bg-navy btn-sm deploy-btn ml-1 mb-1"
                                    href="script.aspx?db=<%=dr["id"] %>"
                                    data-id="<%=dr["id"] %>">
                                    <i class="fas fa-history"></i>
                                    Script History
                                </a>
                                <button class="btn btn-warning btn-sm backup-btn ml-1 mb-1"
                                   
                                   name="backupDb" value="<%=Common.GetDatabase(dr["conn_str"].ToString()) %>"
                                    >
                                    <i class="fas fa-download"></i> Back up
                                </button>
                                <a class="btn bg-indigo btn-sm script-btn ml-1 mb-1" href="#"
                                    data-toggle="modal" data-target="#ScriptModal" data-id='<%=dr["id"]%>'
                                    data-install=false
                                    >
                                    <i class="fas fa-book"></i>
                                    Run Script
                                </a>

                                <a class="btn btn-info btn-sm edit-btn ml-1 mb-1" href="#"
                                    data-toggle="modal" data-target="#EditModal"
                                    data-id='<%=dr["id"]%>'
                                    data-name="<%=dr["name"] %>"
                                    data-database="<%=Common.GetDatabase(dr["conn_str"].ToString()) %>"
                                    data-server="<%=Common.GetServer(dr["conn_str"].ToString()) %>"
                                    data-removable='<%=dr["removable"]%>'>
                                    <i class="fas fa-pencil-alt"></i>
                                    EDIT
                                </a>
                                <%if ((bool)dr["removable"])
                                    { %>
                                <a class="btn btn-danger btn-sm delete-btn" href="#"
                                    data-toggle="modal" data-target="#DeleteModal"
                                    data-name="<%=dr["name"] %>"
                                    data-id='<%=dr["id"]%>'
                                    data-origin='<%=dr["install_db_id"]%>'>
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
        <!-- /.card -->
        </form>
    </section>
    <form method="post" id='NewForm'>
        <div class="modal fade" id="NewModal" tabindex="-1" role="dialog"
            aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="exampleModalLabel">New Database</h5>
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
                        <%=PrintInstallDbList() %>
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
                        <h5 class="modal-title">Eidt Database</h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body">
                        <input type="hidden" class="form-control  col-sm-8" name='id' />
                       
                        <div class="form-group row">
                            <label for="editName" class="col-form-label col-sm-4">Name:</label>
                            <input type="text" class="form-control  col-sm-8" id="editName" name='name'>
                        </div>

                        <div class="form-group row">
                            <label for="editDatabase" class="col-form-label col-sm-4">Database:</label>
                            <input type="text" class="form-control  col-sm-8" id="editDatabase" name='database' />
                        </div>
                        <div class="form-group row">
                            <label for="editServer" class="col-form-label col-sm-4">Server:</label>
                            <input type="text" class="form-control  col-sm-8" id="editServer" name='server' />
                        </div>
                        <div class="form-group row">
                            <label class="col-form-label col-sm-4" for="removableCheck">Removable</label>
                            <input type="checkbox" class="form-control form-control-sm col-sm-1" name="removable" id="removableCheck" value="1">
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
    <form method="post" id='DeleteForm'>
        <div class="modal fade" id="DeleteModal" tabindex="-1" role="dialog"
            aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content bg-danger">
                    <div class="modal-header">
                        <h5 class="modal-title">Delete Database</h5>
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
                            <input type="checkbox" class="form-check-input form-check-input-lg" name="backup" id="backupCheck" value="1">
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
                        <div class="form-check">
                            <input type="checkbox" class="form-check-input " id="cbx1" name="install_db" value="1">
                            <label class="form-check-label" for="cbx1">Update install database</label>
                        </div>
                        <div class="form-group row">
                            <label for="editDatabase" class="col-form-label col-sm-4" id="scriptLabel">Script:</label>

                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                        <button type="submit" name='cmd' value='run' class="btn btn-primary">Save</button>
                    </div>
                </div>
            </div>
        </div>
    </form>
    <!-- /.content -->
</asp:Content>
<asp:Content ContentPlaceHolderID="AdditionalCSS" runat="server">
</asp:Content>
<asp:Content ContentPlaceHolderID="AdditionalJS" runat="server">

    <script src="src/js/database.js"></script>

</asp:Content>
