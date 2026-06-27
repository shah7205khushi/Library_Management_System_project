<td>
                    <a href="edit_admin.jsp?id=<%= id %>" class="btn btn-sm btn-primary">Edit</a>
                    <% if (status == 1) { %>
                        <a href="delete_admin.jsp?id=<%= id %>" class="btn btn-sm btn-danger"
                           onclick="return confirm('Are you sure you want to deactivate this admin?');">Inactive</a>
                    <% } else { %>
                        <button class="btn btn-sm btn-outline-secondary" disabled>Inactive</button>
                    <% } %>
                </td>