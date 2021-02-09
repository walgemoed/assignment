/**
 * Created by Henk Walgemoed<henk.walgemoed@appsolutely.nl>
 */
@IsTest
public inherited sharing class CalloutMock implements HttpCalloutMock {
    /**
     * Mock Responses for Streamics Connector
     *
     */
    public HTTPResponse respond(HTTPRequest req) {
        // Create a mock response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setStatusCode(200);
        return res;
    }
}