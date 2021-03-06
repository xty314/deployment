<%@ Page Language="C#" AutoEventWireup="true" CodeFile="repository.aspx.cs" Inherits="repository" MasterPageFile="./master/_layout.master" %>




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
            <h1>Github Repository</h1>
          </div>
         <div class="col-sm-6">
                    <div class="float-right">
                        <button class="btn bg-blue" data-toggle="modal" data-target="#NewModal"><i
                                class="fa fa-pen"></i> Add New Repo</button>
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

        <div class="card-body p-0" style="display: block;">
            <table class="table table-striped table-hover projects">
                    <thead>
                        <tr>
                            <th style="width: 1%">
                                #id
                            </th>
                            <th style="width: 15%">
                                Repo Name
                            </th>
                               <th style="width: 30%">
                                Repo
                            </th>
                            <th >
                                Description
                            </th>
                            <th class="text-center" >
                               Private
                            </th>

                            <th class="text-right">
                                Action
                            </th>
                        </tr>
                    </thead>
                    <tbody>
                        <%foreach (DataRow dr in  repoDataTable.Rows)
                            {%>
                         <tr>
                            <td>
                                #<%=dr["id"]%>
                            </td>
                            <td>
                               
                                    <%=dr["name"] %>
                               
                               
                            </td>
                                  <td>
                                <a>
                                    <%=dr["url"] %>
                                </a>
                               
                            </td>
                            <td>
                                    <%=dr["description"] %>
                            </td>
                            <td class="project_progress  text-center">
                                <%=dr["private"] %>             
                            </td>

                            <td class="project-actions text-right">
                            
                   
                                
                                <a class="btn btn-info btn-sm edit-btn" href="#" 
                                        data-toggle="modal" data-target="#EditModal"
                                         data-id=<%=dr["id"]%>
                                        data-name="<%=dr["name"] %>"
                                    data-description="<%=dr["description"] %>"
                                    data-private="<%=dr["private"] %>"
                                      data-url="<%=dr["url"] %>"
               
                                        >
                                    <i class="fas fa-pencil-alt">
                                    </i>
                                   EDIT
                                </a>
                             
                                  <a class="btn btn-danger btn-sm delete-btn" href="#" 
                                        data-toggle="modal" data-target="#DeleteModal"
                                       data-name="<%=dr["name"] %>"
                                       data-id=<%=dr["id"]%>
                     
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
     <form  method="post" id='NewForm'>
        <div class="modal fade" id="NewModal" tabindex="-1" role="dialog" 
            aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="exampleModalLabel">New Github Repository</h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body">

                        <div class="form-group row">
                            <label for="recipient-name" class="col-form-label col-sm-4">Repo Name:</label>
                            <input type="text" class="form-control  col-sm-8" name='name'>
                        </div>
                        <div class="form-group row">
                            <label for="recipient-name" class="col-form-label col-sm-4">URL:</label>
                            <input type="text" class="form-control  col-sm-8" name='url'  />
                        </div>
                   
                     <div class="form-group row">
                        <label class="col-form-label col-sm-4">Description</label>
                        <textarea class="form-control col-sm-8" rows="3" name ="description" placeholder="Description ..." style="margin-top: 0px; margin-bottom: 0px; height: 105px;"></textarea>
                      </div>
                            <div class="form-group row"">
                             <label class="col-form-label col-sm-4" for="privateCheck">Private</label>
                            <input type="checkbox" class="form-control form-control-sm col-sm-1" name="private" id="privateCheck" value=1>
                           
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
    <form  method="post" id='EditForm'>
        <div class="modal fade" id="EditModal" tabindex="-1" role="dialog" 
            aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Eidt Repo</h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body">
                         <input type="hidden" class="form-control  col-sm-8" name='id' />
                 
                          <div class="form-group row">
                            <label for="recipient-name" class="col-form-label col-sm-4">Repo Name:</label>
                            <input type="text" class="form-control  col-sm-8" name='name'>
                        </div>
                        <div class="form-group row">
                            <label for="recipient-name" class="col-form-label col-sm-4">URL:</label>
                            <input type="text" class="form-control  col-sm-8" name='url'  />
                        </div>
                   
                     <div class="form-group row">
                        <label class="col-form-label col-sm-4">Description</label>
                        <textarea class="form-control col-sm-8" rows="3" name ="description" placeholder="Description ..." style="margin-top: 0px; margin-bottom: 0px; height: 105px;"></textarea>
                      </div>
                            <div class="form-group row"">
                             <label class="col-form-label col-sm-4" for="privateCheck">Private</label>
                            <input type="checkbox" class="form-control form-control-sm col-sm-1" name="private" id="privateCheck" value=1>
                           
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
    <form  method="post" id='DeleteForm'>
        <div class="modal fade" id="DeleteModal" tabindex="-1" role="dialog"
            aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content bg-danger">
                    <div class="modal-header">
                        <h5 class="modal-title">Delete Repo</h5>
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
     <script src="src/js/repository.js"></script>
 
</asp:Content>
