package win.servername.api.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;

import static win.servername.Constants.*;

@RestController
@RequestMapping(API_MAPPING)
@RequiredArgsConstructor
public class VersionController {
    @GetMapping(API_VERSION_CHECK)
    public ResponseEntity<HashMap<String, String>> getAPIVersion(){
        HashMap<String, String> version = new HashMap<>();

        version.put("version", API_VERSION);

        return ResponseEntity.ok(version);
    }
}
