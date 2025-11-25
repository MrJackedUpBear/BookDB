package win.servername.BookDB;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultHandlers.print;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import jakarta.transaction.Transactional;
import org.junit.jupiter.api.Test;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.security.test.context.support.WithMockUser;
import org.springframework.test.web.servlet.MockMvc;

@SpringBootTest
@AutoConfigureMockMvc
class BookDbApplicationTests {
    private final MockMvc mockMvc;

    private final String BOOK = """
    {
        "isbn": "123456789",
        "title": "Title",
        "description": "description",
        "author": "author",
        "publishDate": "2024-11-24",
        "publisher": "publisher",
        "language": "language",
        "imageLoc": "imageLoc",
        "reviews": [],
        "bookAvailability": [
            {
                "user": {
                    "username":"mrjackedupbear"
                }
            }
        ]
    }
    """;

    private final String REVIEW = """
    {
       "title": "title",
       "description": "description",
       "rating": 5,
       "user": {
           "username": "mrjackedupbear"
       },
       "book": %s
   }
   """.formatted(BOOK);

    @Autowired // Optional for single constructor
    public BookDbApplicationTests(MockMvc mockMvc) {
        this.mockMvc = mockMvc;
    }

    //Get books test for administrator users
    @Test
    @WithMockUser(username = "test", password = "password", authorities = {"Admin"})
    void adminUserGetBooksTest() throws Exception {
        this.mockMvc.perform(get("/api/v1/books"))
                .andDo(print())
                .andExpect(status().isOk());
    }

    //Get books test for elevated users
    @Test
    @WithMockUser(username = "test", password = "password", authorities = {"Elevated User"})
    void elevatedUserGetBooksTest() throws Exception {
        this.mockMvc.perform(get("/api/v1/books"))
                .andDo(print())
                .andExpect(status().isOk());
    }

    //Get books test for general users
    @Test
    @WithMockUser(username = "test", password = "password", authorities = {"General User"})
    void generalUserGetBooksTest() throws Exception {
        this.mockMvc.perform(get("/api/v1/books"))
                .andDo(print())
                .andExpect(status().isOk());
    }

    //Add book test for admin
    @Test
    @Transactional
    @WithMockUser(username = "test", password = "password", authorities = {"Admin"})
    void adminAddBookTest() throws Exception {
        this.mockMvc.perform(post("/api/v1/elevateduser/book")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(BOOK))
                .andDo(print())
                .andExpect(status().isOk());
        this.mockMvc.perform(delete("/api/v1/admin/book")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(BOOK))
                .andDo(print())
                .andExpect(status().isOk());
    }

    //Add book test for elevated user
    @Test
    @Transactional
    @WithMockUser(username = "test", password = "password", authorities = {"Elevated User"})
    void elevatedUserAddBookTest() throws Exception {
        this.mockMvc.perform(post("/api/v1/elevateduser/book")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(BOOK))
                .andDo(print())
                .andExpect(status().isOk());
        this.mockMvc.perform(delete("/api/v1/admin/book")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(BOOK))
                .andDo(print())
                .andExpect(status().is4xxClientError());
    }

    //Add book test for general user
    @Test
    @Transactional
    @WithMockUser(username = "test", password = "password", authorities = {"General User"})
    void generalUserAddBookTest() throws Exception {
        this.mockMvc.perform(post("/api/v1/elevateduser/book")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(BOOK))
                .andDo(print())
                .andExpect(status().is4xxClientError());
        this.mockMvc.perform(delete("/api/v1/admin/book")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(BOOK))
                .andDo(print())
                .andExpect(status().is4xxClientError());
    }

    //Add review test for admin
    @Test
    @Transactional
    @WithMockUser(username = "test", password = "password", authorities = {"Admin"})
    void adminAddReviewTest() throws Exception {
        this.mockMvc.perform(post("/api/v1/elevateduser/book")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(BOOK))
                .andDo(print())
                .andExpect(status().isOk());
        this.mockMvc.perform(post("/api/v1/review")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(REVIEW))
                .andDo(print())
                .andExpect(status().isOk());
        this.mockMvc.perform(delete("/api/v1/admin/review")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(REVIEW))
                .andDo(print())
                .andExpect(status().isOk());
    }

    //Add review test for elevated user
    @Test
    @Transactional
    @WithMockUser(username = "test", password = "password", authorities = {"Elevated User"})
    void elevatedUserAddReviewTest() throws Exception {
        this.mockMvc.perform(post("/api/v1/review")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(REVIEW))
                .andDo(print())
                .andExpect(status().isOk());
        this.mockMvc.perform(delete("/api/v1/admin/review")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(REVIEW))
                .andDo(print())
                .andExpect(status().is4xxClientError());
    }

    //Add review test for general user
    @Test
    @Transactional
    @WithMockUser(username = "test", password = "password", authorities = {"General User"})
    void generalUserAddReviewTest() throws Exception {
        this.mockMvc.perform(post("/api/v1/review")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(REVIEW))
                .andDo(print())
                .andExpect(status().isOk());
        this.mockMvc.perform(delete("/api/v1/admin/review")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(REVIEW))
                .andDo(print())
                .andExpect(status().is4xxClientError());
    }
}