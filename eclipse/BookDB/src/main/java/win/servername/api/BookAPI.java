package win.servername.api;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.domain.EntityScan;

@SpringBootApplication
@EntityScan("win.servername.entity")
public class BookAPI {
    public static void main(String[] args){
        SpringApplication.run(BookAPI.class, args);
    }
}
