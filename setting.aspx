<%@ Page Language="C#" AutoEventWireup="true" CodeFile="setting.aspx.cs" Inherits="setting"  MasterPageFile="./master/_layout.master" %>


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
            <h1>Setting</h1>
          </div>
         <div class="col-sm-6">
                    <div class="float-right">
                     <%--   <button class="btn bg-blue" data-toggle="modal" data-target="#NewCompanyModal"><i
                                class="fa fa-pen"></i> Add New Company </button>--%>
                   
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
      <div class="container-fluid">
        <div class="row">
          <!-- left column -->
          <div class="col-md-12">
            <!-- jquery validation -->
            <div class="card card-primary">
              <div class="card-header">
                <%--<h3 class="card-title">Setting</h3>--%>
              </div>
              <!-- /.card-header -->
              <!-- form start -->
              <form id="quickForm" action="?cmd=save" method="post" novalidate="novalidate">
                <div class="card-body">
                    <%foreach (DataRow dr in settingDataTable.Rows)
                        {%>
                    <%if (dr["type"].ToString() == "bool")
                        { %>
                            <div class="form-group row">
                        <label for="<%=dr["name"]%>" class="col-sm-2 col-form-label text-lg-right"><%=dr["title"] %> <i class="far fa-question-circle" data-toggle="tooltip" title="<%=dr["description"] %>"></i></label>
                        <div class="col-sm-4">
                            <div class="icheck-primary">
                                <input type="checkbox" id="<%=dr["name"]%>"  onclick="document.getElementById('<%=dr["id"]%>').value=this.checked?1:0;" 
                                    <%if (dr["value"].ToString().ToLower() == "1")
                                    {%>
                                     checked
                                    <%} %> />
                                  <input type="hidden" name="<%=dr["name"]%>" id="<%=dr["id"]%>" value="<%=dr["value"]%>">
                           <label for=<%=dr["name"]%>>
                                </label>
                            </div>
                        </div>
                    </div>
                    <%}
                    else
                    { %>
                    <div class="form-group row">
                        <label for="<%=dr["name"]%>" class="col-sm-2 col-form-label text-lg-right"><%=dr["title"] %> <i class="far fa-question-circle" data-toggle="tooltip" title="<%=dr["description"] %>"></i></label>
                        <div class="col-sm-4">
                            <input type="email" class="form-control" id="<%=dr["name"]%>" name="<%=dr["name"]%>" value="<%=dr["value"] %>" placeholder="<%=dr["title"] %>">
                        </div>
                    </div>
                    <%}
                    } %>
         
          

                </div>
                <!-- /.card-body -->
                <div class="card-footer">
                  <button type="submit" class="btn btn-primary">Submit</button>
                </div>
              </form>
            </div>
            <!-- /.card -->
            </div>
          <!--/.col (left) -->
          <!-- right column -->
          <div class="col-md-6">

          </div>
          <!--/.col (right) -->
        </div>
        <!-- /.row -->
      </div><!-- /.container-fluid -->
    </section>
    
 <!-- /.content -->
</asp:Content>
<asp:Content ContentPlaceHolderId="AdditionalJS" runat="server">

</asp:Content>