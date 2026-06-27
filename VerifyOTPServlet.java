import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.IOException;
import java.nio.file.Path;
import java.nio.file.Paths;

@MultipartConfig
public class UploadServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            Part filePart = request.getPart("file");
            String fileName = filePart.getSubmittedFileName();
            Path filePath = Paths.get("upload", fileName);
            filePart.write(filePath.toString());
            response.getWriter().println("File uploaded successfully: " + fileName);
        } catch (Exception e) {
            response.getWriter().println("Error uploading file: " + e.getMessage());
        }
    }
}