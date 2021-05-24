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
              <form id="quickForm" novalidate="novalidate">
                <div class="card-body">
                    <%foreach (DataRow dr in settingDataTable.Rows)
                        {%>
                    <%if (dr["type"] == "bool")
                        { %>
                    <div class="form-group row">
                        <label for="inputEmail3" class="col-sm-2 col-form-label text-lg-right">Email</label>
                        <div class="col-sm-4">
                            <div class="icheck-primary">
                                <input type="checkbox" id="checkboxPrimary1" checked="">
                                <label for="checkboxPrimary1">
                                </label>
                            </div>
                        </div>
                    </div>
                    <%}
                    else
                    { %>
                    <div class="form-group row">
                        <label for="inputEmail3" class="col-sm-2 col-form-label text-lg-right"><%=dr["title"] %> <i class="far fa-question-circle" data-toggle="tooltip" title="<%=dr["description"] %>"></i></label>
                        <div class="col-sm-4">
                            <input type="email" class="form-control" id="inputEmail3" name="<%=dr["id"] %>" value="<%=dr["value"] %>" placeholder="<%=dr["title"] %>">
                        </div>
                    </div>
                    <%}
                    } %>
   <div class="form-group row">
                        <label for="inputEmail3" class="col-sm-2 col-form-label text-lg-right">Email</label>
                        <div class="col-sm-4">
                            <div class="icheck-primary">
                                <input type="checkbox" id="checkboxPrimary1"  onclick="document.all.test.value=this.checked?1:0" 
                                    <%if (1 == 2)
                                    {%>
                                     checked
                                    <%} %>
                                  <input type="hidden" id="checkboxPrimary1" name="test" value="0">
                                <label for="checkboxPrimary1">
                                </label>
                            </div>
                        </div>
                    </div>


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