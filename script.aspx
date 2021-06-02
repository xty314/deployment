<%@ Page Language="C#" AutoEventWireup="true" CodeFile="script.aspx.cs" Inherits="script"  MasterPageFile="./master/_layout.master" %>




<%--import MasterPageFile--%>


<%@Import Namespace="System.Data.SqlClient" %>
<%@Import Namespace ="System.Data" %>


<asp:Content ContentPlaceHolderId="Header" runat="server">
  <section class="content-header">
      <div class="container-fluid">
        <div class="row mb-2">
          <div class="col-sm-6">
            <h1>Sql Script</h1>
          </div>
         <div class="col-sm-6">
                    <div class="float-right">
                         <button class="btn bg-blue" data-toggle="modal" data-target="#NewModal"><i
                                class="fa fa-pen"></i> Create Script</button>
                        <button class="btn bg-blue" data-toggle="modal" data-target="#UploadModal"><i
                                class="fa fa-file"></i> Upload Script</button>
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
        <div class="row">
         <div class="col-md-6">
              <div class="card">
        <div class="card-header">
          <h3 class="card-title"><%=DBName%></h3>

          <div class="card-tools">
            <button type="button" class="btn btn-tool" data-card-widget="collapse" title="Collapse">
              <i class="fas fa-minus"></i>
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
                               Name
                            </th>
                  
                            <th class="text-center" >
                               Description
                            </th>
                              <th class="text-center" >
                              Upload Date
                            </th>
                              <%if (string.IsNullOrEmpty(Request.QueryString["db"])){%>
                            <th class="text-right">
                                Action
                            </th>
                              <%} %>
                        </tr>
                    </thead>
                    <tbody>
                        <%foreach (DataRow dr in scriptDataTable.Rows)
                            {%>
                         <tr>
                            <td>
                                #<%=dr["id"]%>
                            </td>
                            <td>
                                <a href="script.aspx?id=<%=dr["id"]%>">
                                    <%=dr["name"] %>
                                </a>
                               
                            </td>
         
                            <td class="project_progress  text-center">
                                     <%=dr["description"] %>          
                            </td>
                                 <td class="project_progress  text-center">
                                     <%=dr["upload_date"] %>          
                            </td>
                             <%if (string.IsNullOrEmpty(Request.QueryString["db"])){%>
                             <td class="project-actions text-right">
                                 <div class="btn-group">
                                     <button type="button" class="btn btn-primary  btn-sm dropdown-toggle dropdown-icon" data-toggle="dropdown">
                                         Action
                                     </button>
                                     <div class="dropdown-menu" role="menu">
                                          <a class="dropdown-item" href="?download=<%=dr["id"] %>"><i class="fas fa-download"></i> Download</a>

                                         <div class="dropdown-divider"></div>
                                         <a class="dropdown-item editBtn" data-toggle="modal" data-target="#EditModal" data-id="<%=dr["id"] %>" data-location="<%=dr["location"] %>" data-name="<%=dr["name"] %>" 
                                             data-description="<%=dr["description"] %>"><i class="fas fa-pencil-alt"></i> EDIT</a>

                                         <div class="dropdown-divider"></div>
                                         <a class="dropdown-item deleteBtn" data-toggle="modal" data-target="#DeleteModal" data-id="<%=dr["id"] %>"><i class="fas fa-trash"></i> Delete</a>
                                     </div>
                                 </div>
                             </td>
                             <%} %>
                        </tr>
                        <%} %>
         

                    </tbody>
                </table>
        </div>
        <!-- /.card-body -->
      </div>
         </div>
            <%if (!String.IsNullOrEmpty(Request.QueryString["id"]) && Common.IsNumberic(Request.QueryString["id"])){ %>
           <div class="col-md-6">
               <form method="post">
          <div class="card card-outline card-info">
            <div class="card-header">
              <h3 class="card-title">
               <%=ScriptName(Request.QueryString["id"]) %>
              </h3>
            </div>
            <!-- /.card-header -->
            <div class="card-body p-0">
              <textarea class="codeMirror" name="content" class="p-3"><%=ScriptContent(Request.QueryString["id"]) %></textarea>
            </div>

          </div>
                   </form>
        </div>
        <%} %>
            <!-- /.col-->
             
      </div>
      <!-- Default box -->
    
      <!-- /.card -->

    </section>
     <form  method="post" id='NewForm' enctype="multipart/form-data">
        <div class="modal fade" id="NewModal" tabindex="-1" role="dialog"     aria-hidden="true">
            <div class="modal-dialog modal-lg" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Create Script</h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body"  >
                           <div class="form-group">
                        <label class="col-form-label col-sm-4">Sql Script：</label>
                     <textarea class="codeMirror p-3"  style="height:300px" name="content" ></textarea>

                      </div>
                         
                           <div class="form-group row">
                            <label for="recipient-name" class="col-form-label col-sm-4">Name:</label>
                            <input type="text" class="form-control  col-sm-8"  name='name'>
                        </div>
                       
                     <div class="form-group row">
                        <label class="col-form-label col-sm-4">Description</label>
                        <textarea class="form-control col-sm-8" rows="3" name ="description" placeholder="Description ..." style="margin-top: 0px; margin-bottom: 0px; height: 105px;"></textarea>
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
         <form  method="post" id='UploadForm' enctype="multipart/form-data">
        <div class="modal fade" id="UploadModal" tabindex="-1" role="dialog" 
            aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="exampleModalLabel">Upload Script</h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body">

                        <div class="form-group row">
                            <label for="recipient-name" class="col-form-label col-sm-4">Name:</label>
                            <input type="text" class="form-control  col-sm-8" id="scriptName" name='name'>
                        </div>
                   <%--     <div class="form-group row">
                         
                            <input type="text" class="form-control  col-sm-8" name='server' value="<%= Common.GetSetting("db_server")%>" />
                        </div>--%>
                 <div class="form-group row">
                    <!-- <label for="customFile">Custom File</label> -->
                        <label for="recipient-name" class="col-form-label col-sm-4">File:</label>
                    <div class="custom-file col-sm-8">
                      <input type="file" class="custom-file-input" id="scriptFile" name="scriptFile">
                      <label class="custom-file-label" for="customFile">Choose file</label>
                    </div>
                  </div>
                     <div class="form-group row">
                        <label class="col-form-label col-sm-4">Description</label>
                        <textarea class="form-control col-sm-8" rows="3" name ="description" placeholder="Description ..." style="margin-top: 0px; margin-bottom: 0px; height: 105px;"></textarea>
                      </div>
                        <%-- <input type="hidden" class="form-control  col-sm-10" name='company' id="s_new_sscat">--%>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                        <button type="submit" name='cmd' value='upload' class="btn btn-primary">Save</button>
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
                        <h5 class="modal-title">Eidt Script Info</h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body">
                         <input type="hidden" class="form-control  col-sm-8" name='id' />
                         Location <h5 id="location"></h5>
                        <div class="form-group row">
                            <label for="recipient-name" class="col-form-label col-sm-4">Name:</label>
                            <input type="text" class="form-control  col-sm-8" name='name'>
                        </div>
                 <div class="form-group row">
                        <label class="col-form-label col-sm-4">Description</label>
                        <textarea class="form-control col-sm-8" rows="3" name ="description" placeholder="Description ..." style="margin-top: 0px; margin-bottom: 0px; height: 105px;"></textarea>
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
                        <h5 class="modal-title">Delete Script</h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body" id="DeleteModalBody">
                        <input type="hidden" class="form-control  col-sm-8" name='id' />
                        <h5 id="deletePrompt">
                            Are you sure to delete this script?
                        </h5>
                       
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

<asp:Content ContentPlaceHolderId="AdditionalCSS" runat="server">
   
    <link href="src/plugins/codemirror/codemirror.css" rel="stylesheet" />
     <link href="src/plugins/codemirror/theme/monokai.css" rel="stylesheet" />
    <style>
        .CodeMirror {
  border: 1px solid #eee;
  height: 500px;
}
    </style>
</asp:Content>
<asp:Content ContentPlaceHolderId="AdditionalJS" runat="server">
    <script src="src/plugins/bs-custom-file-input/bs-custom-file-input.min.js"></script>
 
    <script src="src/plugins/codemirror/codemirror.js"></script>
    <script src="src/plugins/codemirror/mode/sql/sql.js"></script>
    <script src="src/js/script.js"></script>
    <script>

    </script>
 
</asp:Content>