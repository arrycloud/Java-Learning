import java.io.FileWriter;
import java.io.IOException;
import java.time.LocalDateTime;

public class HelloWorld {
    public static void main(String[] args) {
        System.out.println("Hello from Jenkins Java Script!");
        try {
            FileWriter writer = new FileWriter("activity.log", true);
            writer.write("Job executed at: " + LocalDateTime.now() + "\n");
            writer.close();
            System.out.println("Successfully updated activity.log");
        } catch (IOException e) {
            System.out.println("An error occurred.");
            e.printStackTrace();
        }
    }
}
