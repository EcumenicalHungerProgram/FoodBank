public class ReportPickerController {
  public ReportParams__c report_params { get; set;}
  public Map<String, String> report_map {get; set;}

  public ReportPickerController () {
    report_params = new ReportParams__c();
    report_map = new Map<String, String>();
    report_map.put('Income and Ethnicity', 'IncomeEthnicity');
    report_map.put('Demographics', 'Demographics');
    report_map.put('Demographics Plus', 'DemographicsPlus');
    report_map.put('Missed Appointments', 'MissedAppointments');
  }
  
  public PageReference getReport() {
    Date start_date = report_params.StartDate__c;
    Date end_date = report_params.EndDate__c;
    String report_type = report_params.ReportType__c;
    PageReference reportPage = new PageReference('/apex/' + report_map.get(report_type));
    reportPage.getParameters().put('start_date', start_date.format());
    reportPage.getParameters().put('end_date', end_date.format());
    return reportPage;
  }
}