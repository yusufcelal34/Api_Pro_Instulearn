package runners;

import io.cucumber.junit.Cucumber;
import io.cucumber.junit.CucumberOptions;
import org.junit.runner.RunWith;

@RunWith(Cucumber.class)
@CucumberOptions(
        plugin = {
                "pretty",
                "html:target/default-cucumber-reports.html",
                "json:target/json-reports/cucumber.json",
                "junit:target/xml-report/cucumber.xml",
                "rerun:target/failedRerun.txt",
        },
        features = "src/test/resources/features/api/feature", // ← narrow the scope
        glue = {"stepdefinitions","hooks","utilities"},


        tags = "@DB1",
        dryRun =false

)
public class Runner {}

