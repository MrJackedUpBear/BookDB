package win.servername.api.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import win.servername.api.service.UserService;

import static win.servername.Constants.API_MAPPING;

@RestController
@RequestMapping(API_MAPPING)
public class UserController {
    private final UserService userService;

    @Autowired
    public UserController(UserService userService){
        this.userService = userService;
    }
}
