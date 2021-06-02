<%@ Page Language="C#" AutoEventWireup="true" CodeFile="database.aspx.cs" Inherits="database"  MasterPageFile="./master/_layout.master"%>


<%--import MasterPageFile--%>


<%@Import Namespace="System.Data.SqlClient" %>
<%@Import Namespace ="System.Data" %>
<asp:Content ContentPlaceHolderId="AdditionalCSS" runat="server">


</asp:Content>

<asp:Content ContentPlaceHolderId="Header" runat="server">
  <section class="content-header">
      <div class="container-fluid">
        <div class="row mb-2">
          <div class="col-sm-6">
            <h1>Database</h1>
          </div>
         <div class="col-sm-6">
                    <div class="float-right">
                        <button class="btn bg-blue" data-toggle="modal" data-target="#NewModal"><i
                                class="fa fa-pen"></i> Add New Database</button>
                         <%--<button class="btn bg-blue" data-toggle="modal" data-target="#NewCompanyModal"><i
                                class="fa fa-pen"></i>Update </button>--%>
                        <%-- <button type="button" class="btn btn-success"><i class="fa fa-download"></i>Export </button>--%>
                    </div>
                </div>
        </div>
      </div><!-- /.container-fluid -->
    </section>


</asp:Content>
<asp:Content ContentPlaceHolderId="Content" runat="server">
 
  <!-- Main content -->
    <section class="content">
               <%if (!String.IsNullOrEmpty(info)){ %>
        <div class="col-lg-12">
                        <div class="callout callout-danger">
                            <h5><%=info %></h5>

                        </div>
                    </div>
        <%} %>
      <!-- Default box -->
      <div class="card">
        <div class="card-header">
          <h3 class="card-title">Projects</h3>

          <div class="card-tools">
            <button type="button" class="btn btn-tool" data-card-widget="collapse" title="Collapse">
              <i class="fas fa-minus"></i>
            </button>
            <button type="button" class="btn btn-tool" data-card-widget="remove" title="Remove">
              <i class="fas fa-times"></i>
            </button>
          </div>
        </div>
        <div class="card-body p-0" style="display: block;">
            <table class="table table-striped table-hover projects">
                    <thead>
                        <tr>
                            <th style="width: 1%">
                                #id
                            </th>
                            <th style="width: 15%">
                                DB Name
                            </th>
                            <th style="width: 20%">
                                Origin
                            </th>
                            <th class="text-center" style="width: 40%">
                                Create Date
                            </th>

                            <th style="width: 20%" class="text-right">
                                Action
                            </th>
                        </tr>
                    </thead>
                    <tbody>
                        <%foreach (DataRow dr in dbDataTable.Rows)
                            {%>
                         <tr>
                            <td>
                                #<%=dr["id"]%>
                            </td>
                            <td>
                                <a>
                                    <%=dr["name"] %>
                                </a>
                               
                            </td>
                            <td>
              <%--                <a href="<%="http://" + Request.Url.Host+"/m/" + dr["ReportDir"]+"/index.aspx"%>"
                                    target="_blank"><%="http://" + Request.Url.Host+"/m/" + dr["ReportDir"]+"/index.aspx"%> </a>--%>
                            </td>
                            <td class="project_progress  text-center">
                                               
                            </td>

                            <td class="project-actions text-right">
                            
                            <div class="btn-group">
              
                    <button type="button" class="btn btn-primary  btn-sm dropdown-toggle dropdown-icon" data-toggle="dropdown">
                      Action
                    </button>
                    <div class="dropdown-menu" role="menu">
                      <a class="dropdown-item" href="./user.aspx?id=<%=dr["id"]%>"><i class="fas fa-user"></i>USER</a>
                   
                      <div class="dropdown-divider"></div>
                         <a class="dropdown-item" href="./branch.aspx?id=<%=dr["id"]%>"><i class="fas fa-building"></i>BRANCH</a>

                    </div>
                  </div>
                                <a class="btn btn-info btn-sm edit-btn" href="#" 
                                        data-toggle="modal" data-target="#EditModal"
                                         data-id=<%=dr["id"]%>
                                        data-company="<%=dr["name"] %>"
                                      
                                       <%-- data-database="<%=GetDatabase(dr["DbConnectionString"].ToString()) %>"
                                        data-server="<%=GetServer(dr["DbConnectionString"].ToString()) %>"--%>
                                        data-removable=<%=dr["removable"]%>
                         <%--               data-dir=<%=dr["ReportDir"]%>--%>
                                        >
                                    <i class="fas fa-pencil-alt">
                                    </i>
                                   EDIT
                                </a>
                                <%if ((bool)dr["removable"]){ %>
                                  <a class="btn btn-danger btn-sm delete-btn" href="#" 
                                        data-toggle="modal" data-target="#DeleteCompanyModal"
                                       data-company="<%=dr["name"] %>"
                                       data-id=<%=dr["id"]%>
                              <%--         data-dir=<%=dr["ReportDir"]%>--%>
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
     <form  method="post" id='NewForm'>
        <div class="modal fade" id="NewModal" tabindex="-1" role="dialog" 
            aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="exampleModalLabel">New Company</h5>
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
    <form  method="post" id='EditForm'>
        <div class="modal fade" id="EditModal" tabindex="-1" role="dialog" 
            aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Eidt Company</h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body">
                         <input type="hidden" class="form-control  col-sm-8" name='id' />
                        <input type="hidden" class="form-control  col-sm-8" name='reportDir' />
                        <div class="form-group row">
                            <label for="recipient-name" class="col-form-label col-sm-4">Company Name:</label>
                            <input type="text" class="form-control  col-sm-8" name='company'>
                        </div>
                         <div class="form-group row">
                            <label for="recipient-name" class="col-form-label col-sm-4">Api:</label>
                            <input type="text" class="form-control  col-sm-8" name='api' />
                        </div>
                         <div class="form-group row">
                            <label for="recipient-name" class="col-form-label col-sm-4">Database:</label>
                            <input type="text" class="form-control  col-sm-8" name='database' />
                        </div>
                        <div class="form-group row">
                            <label for="recipient-name" class="col-form-label col-sm-4">Server:</label>
                            <input type="text" class="form-control  col-sm-8" name='server' />
                        </div>
                        <div class="form-group row"">
                             <label class="col-form-label col-sm-4" for="removableCheck">Removable</label>
                            <input type="checkbox" class="form-control form-control-sm col-sm-1" name="removable" id="removableCheck" value=1>
                           
                        </div>
                        <%-- <input type="hidden" class="form-control  col-sm-10" name='company' id="s_new_sscat">--%>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                        <button type="submit" name='cmd' value='edit' class="btn btn-primary">Save</button>
                    </div>
                </div>
            </div>
        </div>
    </form>
    <form  method="post" id='DeleteForm'>
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
                        <input type="hidden" class="form-control  col-sm-8" name='reportDir' />
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
 <!-- /.content -->
</asp:Content>
<asp:Content ContentPlaceHolderId="AdditionalJS" runat="server">


</asp:Content>