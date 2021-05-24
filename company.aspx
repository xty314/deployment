<%@ Page Language="C#" AutoEventWireup="true" CodeFile="company.aspx.cs" Inherits="v2_invoice" MasterPageFile="./master/_layout.master" %>



<%--注意加入MasterPageFile--%>



<%@Import Namespace="System.Data.SqlClient" %>
<%@Import Namespace ="System.Data" %>
<asp:Content ContentPlaceHolderID="AdditionalCSS" runat="server">
</asp:Content>

<asp:Content ContentPlaceHolderID="Header" runat="server">
    <div class="content-header">
        <div class="container">
            <div class="row mb-2">
                <div class="col-sm-6">
                    <h1 class="m-0 text-dark" id="Title1">Company</h1>
                </div>
                <!-- /.col -->
                <div class="col-sm-6">
                    <div class="float-right">
                        <button class="btn bg-blue" data-toggle="modal" data-target="#NewCompanyModal"><i
                                class="fa fa-pen"></i> Add New Company </button>
                         <%--<button class="btn bg-blue" data-toggle="modal" data-target="#NewCompanyModal"><i
                                class="fa fa-pen"></i>Update </button>--%>
                        <%-- <button type="button" class="btn btn-success"><i class="fa fa-download"></i>Export </button>--%>
                    </div>
                </div>
                <!-- /.col -->
            </div>
            <!-- /.row -->
        </div>
        <!-- /.container-fluid -->
    </div>

</asp:Content>
<asp:Content ContentPlaceHolderID="Content" runat="server">

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
            <div class="card-body p-0">
                <table class="table table-striped table-hover projects">
                    <thead>
                        <tr>
                            <th style="width: 1%">
                                #id
                            </th>
                            <th style="width: 15%">
                                Company
                            </th>
                            <th style="width: 20%">
                                 MReport URL
                            </th>
                            <th class="text-center" style="width: 40%">
                                API
                            </th>

                            <th style="width: 20%" class="text-right">
                                Action
                            </th>
                        </tr>
                    </thead>
                    <tbody>
                    <%--    <%foreach (DataRow dr in companyDataTable.Rows)
                            {%>
                         <tr>
                            <td>
                                #<%=dr["id"]%>
                            </td>
                            <td>
                                <a>
                                    <%=dr["TradingName"] %>
                                </a>
                               
                            </td>
                            <td>
                              <a href="<%="http://" + Request.Url.Host+"/m/" + dr["ReportDir"]+"/index.aspx"%>"
                                    target="_blank"><%="http://" + Request.Url.Host+"/m/" + dr["ReportDir"]+"/index.aspx"%> </a>
                            </td>
                            <td class="project_progress  text-center">
                               Sync API： <small><%=dr["ApiBase"].ToString() + dr["SyncApi"].ToString()%></small> <button class="btn btn-success btn-sm copy-btn" >copy</button>
                             <br>
                               Mreport API：   <small><%=dr["ApiBase"].ToString() + dr["ReportApi"].ToString()%></small>
                             <br>                                
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
                                        data-toggle="modal" data-target="#EditCompanyModal"
                                         data-id=<%=dr["id"]%>
                                        data-company="<%=dr["TradingName"] %>"
                                        data-api="<%=dr["ApiBase"] %>"
                                        data-database="<%=GetDatabase(dr["DbConnectionString"].ToString()) %>"
                                        data-server="<%=GetServer(dr["DbConnectionString"].ToString()) %>"
                                        data-removable=<%=dr["removable"]%>
                                        data-dir=<%=dr["ReportDir"]%>
                                        >
                                    <i class="fas fa-pencil-alt">
                                    </i>
                                   EDIT
                                </a>
                                <%if ((bool)dr["removable"]){ %>
                                  <a class="btn btn-danger btn-sm delete-btn" href="#" 
                                        data-toggle="modal" data-target="#DeleteCompanyModal"
                                       data-company="<%=dr["TradingName"] %>"
                                       data-id=<%=dr["id"]%>
                                       data-dir=<%=dr["ReportDir"]%>
                                      >
                                    <i class="fas fa-trash">
                                    </i>
                                   DELETE
                                </a>
                                <%} %>
                            </td>
                        </tr>
                        <%} %>
         --%>

                    </tbody>
                </table>
            </div>
            <!-- /.card-body -->
        </div>
        <!-- /.card -->

    </section>
    <!-- /.content -->
    <form action="company.aspx" method="post" id='NewCompanyForm'>
        <div class="modal fade" id="NewCompanyModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel"
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
                            <label for="recipient-name" class="col-form-label col-sm-4">Company Name:</label>
                            <input type="text" class="form-control  col-sm-8" name='company'>
                        </div>
                        <div class="form-group row">
                            <label for="recipient-name" class="col-form-label col-sm-4">DB Server:</label>
                            <input type="text" class="form-control  col-sm-8" name='server' value="<%= Common.GetSetting("DataSource")%>" />
                        </div>
                         <div class="form-check">
                    <input type="checkbox" class="form-check-input form-check-input-lg" name="createDb" id="DbCheck"  value="1" >
                    <label class="form-check-label" for="DbCheck">create a new Database for the new site.</label>
                  </div>
                        <%-- <input type="hidden" class="form-control  col-sm-10" name='company' id="s_new_sscat">--%>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                        <button type="submit" name='cmd' value='addNewCompany' class="btn btn-primary">Save</button>
                    </div>
                </div>
            </div>
        </div>
    </form>
    <form action="company.aspx" method="post" id='EditCompanyForm'>
        <div class="modal fade" id="EditCompanyModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel"
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
                        <button type="submit" name='cmd' value='editCompany' class="btn btn-primary">Save</button>
                    </div>
                </div>
            </div>
        </div>
    </form>
    <form action="company.aspx" method="post" id='DeleteCompanyForm'>
        <div class="modal fade" id="DeleteCompanyModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel"
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
                        <button type="submit" name='cmd' value="deleteCompany" class="btn btn-primary" id="DeleteModalBtn">Delete</button>
                    </div>
                </div>
            </div>
        </div>
    </form>
</asp:Content>
<asp:Content ContentPlaceHolderID="AdditionalJS" runat="server">
    <script src="src/plugins/bootstrap4-duallistbox/jquery.bootstrap-duallistbox.min.js"></script>
    <script src="src/js/company.js"></script>

</asp:Content>