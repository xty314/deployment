<%@ Page Language="C#" AutoEventWireup="true" CodeFile="user.aspx.cs" Inherits="admin_user"  MasterPageFile="./master/_layout.master"%>


<%--注意加入MasterPageFile--%>



<%@Import Namespace="System.Data.SqlClient" %>
<%@Import Namespace ="System.Data" %>
<asp:Content ContentPlaceHolderID="AdditionalCSS" runat="server">
</asp:Content>

<asp:Content ContentPlaceHolderID="Header" runat="server">
    <div class="content-header">
        <div class="container-fluid">
            <div class="row mb-2">
                <div class="col-sm-6">
                    <h1 class="m-0 text-dark" id="Title1"><%=companyName%></h1>
                </div>
                <!-- /.col -->
                <div class="col-sm-6">
                    <div class="float-right">
                        <button class="btn bg-blue" data-toggle="modal" data-target="#NewUserModal"><i
                                class="fa fa-pen"></i> Add New User </button>
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
                              <th style="width: 10%">
                                Name
                            </th>
                            <th style="width: 20%">
                                Email
                            </th>
                

                            <th style="width: 20%" class="text-right">
                                Action
                            </th>
                        </tr>
                    </thead>
                    <tbody>
                     <%foreach (DataRow dr in userDatatable.Rows)
                            {%>
                         <tr>
                            <td>
                                #<%=dr["id"]%>
                            </td>
                             <td>
                                <%=dr["name"]%>
                            </td>
                            <td>
                                <a>
                                    <%=dr["email"] %>
                                </a>
                               
                            </td>
                       
                       

                            <td class="project-actions text-right">
                                
                                    <a class="btn btn-info btn-sm edit-btn" href="#" 
                                   data-toggle="modal" data-target="#EditUserModal"
                                         data-id=<%=dr["id"]%>
                                         data-name=<%=dr["name"]%>
                                         data-email=<%=dr["email"]%>
                                        >
                                    <i class="fas fa-pencil-alt">
                                    </i>
                                   EDIT
                                </a>
                                   <a class="btn btn-danger btn-sm delete-btn" href="#" 
                                        data-toggle="modal" data-target="#DeleteUserModal"
                                          data-id=<%=dr["id"]%>                                      
                                         data-email=<%=dr["email"]%>
                   
                                      >
                                    <i class="fas fa-trash">
                                    </i>
                                   DELETE
                                </a>
                               
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
    <!-- /.content -->
    <form  method="post" id='NewUserForm'>
        <div class="modal fade" id="NewUserModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel"
            aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="exampleModalLabel">New User</h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body">
                        <div class="form-group row">
                            <label for="recipient-name" class="col-form-label col-sm-4">Name:</label>
                            <input type="text" class="form-control  col-sm-8" name='name'>
                        </div>
                        <div class="form-group row">
                            <label for="recipient-name" class="col-form-label col-sm-4">Email:</label>
                            <input type="text" class="form-control  col-sm-8" name='email' />
                        </div>
                        <div class="form-group row">
                            <label for="recipient-name" class="col-form-label col-sm-4">Password:</label>
                            <input type="text" class="form-control  col-sm-8" name='password' />
                        </div>
                    

                        <%-- <input type="hidden" class="form-control  col-sm-10" name='company' id="s_new_sscat">--%>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                        <button type="submit" name='cmd' value='addNewUser' class="btn btn-primary">Save</button>
                    </div>
                </div>
            </div>
        </div>
    </form>
    <form  method="post" id='EditUserForm'>
        <div class="modal fade" id="EditUserModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel"
            aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Eidt User</h5>
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
                            <label for="recipient-name" class="col-form-label col-sm-4">Email:</label>
                            <input type="text" class="form-control  col-sm-8" name='email' />
                        </div>
                          <div class="form-group row" style="display:none" id="passwordRow">
                            <label for="recipient-name" class="col-form-label col-sm-4">New Password:</label>
                            <input type="text" class="form-control  col-sm-8" name='password' disabled/>
                        </div>
                        <div class="form-check">
                            <input type="checkbox" class="form-check-input form-check-input-lg"  id="passwordChange" value="true" name="changePassword" >
                            <label class="form-check-label" for="passwordChange">Change password</label>
                        </div>
                 
         
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                        <button type="submit" name='cmd' value='editUser' class="btn btn-primary">Save</button>
                    </div>
                </div>
            </div>
        </div>
    </form>
     <form  method="post" id='DeleteUserForm'>
        <div class="modal fade" id="DeleteUserModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel"
            aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content bg-danger">
                    <div class="modal-header">
                        <h5 class="modal-title">Delete User</h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body" id="DeleteModalBody">
                        <input type="hidden" class="form-control  col-sm-8" name='id' />            
                        <h5 id="deletePrompt"></h5>  
                    </div>

                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                        <button type="submit" name='cmd' value="deleteUser" class="btn btn-primary" id="DeleteModalBtn">Delete</button>
                    </div>
                </div>
            </div>
        </div>
    </form>
</asp:Content>
<asp:Content ContentPlaceHolderID="AdditionalJS" runat="server">

    <script src="src/js/user.js"></script>

</asp:Content>
