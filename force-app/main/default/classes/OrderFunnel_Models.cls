public with sharing class OrderFunnel_Models {
    public class AccountModel{
        public String id;
        public string name;
        public string phone;
        public AddressModel billingAddress;
        public List<AdditionalFieldModel> additionalFields {get; set;}

        public AccountModel(){
            additionalFields = new List<AdditionalFieldModel>();
        }
    }

    public class ContactModel{
        public string id;
        public string firstName;
        public string lastName;
        public string email;
        public string phone;
        public String accountId;
        public AddressModel mailingAddress;
        public List<AccountModel> accounts;
        public AccountModel account;
        public ContactModel(){
            accounts = new List<AccountModel>();
        }
    }

    public class AddressModel{
        public String street;
        public String city;
        public String state;
        public String postalCode;
        public String country;
        public Decimal latitude;
        public Decimal longitude;
    }

    public class AssetModel {
        public String name {get; set;}
        public String accountId {get; set;}
        public String sfId {get; set;}
        public String teId {get; set;}
        public String cuId {get; set;}
        public String currentTracingId {get; set;}
        public AddressModel address {get; set;}
        public String teRegionId {get;set;}
        public String teRegionName {get;set;}
        public String pricebookId {get;set;}
        public String accessCode {get;set;}
        public String accessNote {get;set;}
        public List<AdditionalFieldModel> additionalFields {get; set;}
        public List<MetricModel> metrics {get; set;}

        public AssetModel(){
            additionalFields = new List<AdditionalFieldModel>();
            metrics = new List<MetricModel>();
        }
    }

    public class AdditionalFieldModel {
        public String id {get; set;}
        public String label {get; set;}
        public String value {get; set;}

        public AdditionalFieldModel(String fieldId, String fieldLabel, String fieldValue) {
            id = fieldId;
            label = fieldLabel;
            value = fieldValue;
        }
    }

    public class MetricModel {
        public String type {get; set;}
        public String value {get; set;}

        public MetricModel(){}

        public MetricModel(String type, String value){
            this.type = type;
            this.value = value;
        }
    }

    public class ProductSearchResultModel {
        public String id;
        public String externalId;
        public String productName;
        public String productCode;
        public String displayName;
        public String productPhotoURL;
        public String type;
        public String description;
        public String family;
        public String merchandisingTags;
        public Boolean clientProduct;
        public List<ServiceTypeModel> serviceTypes;

        public ProductSearchResultModel(){
            serviceTypes = new List<ServiceTypeModel>();
        }
    }

    public class Product2Model {
        public String id;
        public String externalId;
        public String productName;
        public String productCode;
        public String displayName;
        public String productPhotoURL;
        public String type;
        public String description;
        public String family;
        public String merchandisingTags;
        public String netsuiteItem;
        public String taxCode;

        public List<ServiceTypeModel> serviceTypes;

        public Product2Model(){
            ServiceTypes = new List<ServiceTypeModel>();
        }
    }

    public class ServiceTypeModel {
        public String id {get; set;}
        public String name {get; set;}
        public String serviceCode {get; set;}
        public ServiceTypeDescription description {get;set;}
        public List<PhotoSetModel> photoSets {get; set;}

        public ServiceTypeModel(){
            description = new ServiceTypeDescription();
            photoSets = new List<PhotoSetModel>();
        }
    }

    public class ServiceTypeDescription {
        public String contractor {get;set;}
        public String customer {get;set;}
    }

    public class PhotoSetModel {
        public String photoId {get; set;}
        public String photoName {get;set;}
        public String photoDefinitionId {get;set;}
        public String photoDescription {get; set;}
        public String photoExample {get; set;}
        public String photoInstruction {get; set;}
        public String timing {get;set;}
    }

    public class OrderModel {
        public String orderId {get; set;}
        public String orderNumber {get; set;}
        public String orderDate {get; set;}
        public String orderStatus {get; set;}
        public String planType {get; set;}
        public String billingType {get; set;}
        public String paymentFrequency {get; set;}
        public String orderStartDate {get; set;}
        public String orderEndDate {get; set;}
        public String earliestAvailableStartDate {get; set;}
        public String latestAvailableEndDate {get; set;}
        public String workOrderReference {get; set;}
        public String contractor {get; set;}
        public String workCrewId {get; set;}
        public String serviceId {get; set;}
        public String stripeTransactionId {get; set;}
        public AccountModel customer {get; set;}
        public AssetModel asset {get; set;}
        public List<BundleModel> bundles {get; set;}
        public List<AdditionalFieldModel> additionalFields {get; set;}

        public OrderModel(){
            bundles = new List<BundleModel>();
            additionalFields = new List<AdditionalFieldModel>();
        }
    }

    public virtual class OrderItemModel{
        public String type;

        public String id;
        public String parentId;
        public Product2Model product;
    }

    public class BundleModel extends OrderItemModel{
        public String recurrenceType {get; set;}
        public Decimal nteAmount {get; set;}
        public List<PackageModel> packages {get; set;}
        public List<OptionalPackageModel> optionalServices {get; set;}

        public BundleModel(){
            type = 'Bundle';

            packages = new List<PackageModel>();
            optionalServices = new List<OptionalPackageModel>();
        }
    }

    public class PackageModel extends OrderItemModel{
        public String additionalInstructions {get; set;}

        public String scheduleTemplate {get; set;}
        public String scheduleTemplateId {get; set;}
        public String billingSchedule {get; set;}
        public Decimal customerPrice {get; set;}
        public Decimal contractorPayout {get; set;}
        public Decimal glInsuranceCost {get; set;}
        public Decimal oaInsuranceCost {get; set;}
        public Decimal estimatedEffort {get; set;}
        public Decimal estimatedTax {get; set;}
        public Decimal aspTotal {get;set;}

        public List<AdditionalFieldModel> additionalFields {get; set;}

        public PackageModel(){
            type = 'Package';
            additionalFields = new List<AdditionalFieldModel>();
        }
    }

    public class OptionalPackageModel extends OrderItemModel{
        public OptionalPackageModel(){
            type = 'Option';
        }
    }

    public class Pricebook{
        public String pricebookId;
        public String name;
        public String modstamp;
        public Boolean isActive;
        public Set<String> overrides;

        public Pricebook(){
            overrides = new Set<String>();
        }
    }

    public class PricebookEntry{
        public String productId;
        public String productType;
        public String pricebookId;
        public String accountId;
        public String type; //List, Block, Slab
        public Decimal listPrice;
        public Decimal unitPrice; //Price per quantity if type = unit or contracted
        public String propertyMetric; //Only valid for block or schedule pricing
        public List<PriceBlock> blocks; //Only valid if propertyMetric is sset

        public PricebookEntry(){
            blocks = new List<PriceBlock>();
        }
    }

    public class PriceBlock{
        public Decimal metricMin; //Only valid if propertyMetric is set
        public Decimal metricMax; //Only valid if propertyMetric is set
        public Decimal unitPrice;
        public Decimal listPrice;
        public Decimal discount;
        public String discountType;
    }

    public class DMLResponse{
        public String id;
        public String name;
        public String accountId;

        public DMLResponse(String id){
            this.id = id;
        }

        public DMLResponse(String id, String accountId){
            this.id = id;
            this.accountId = accountId;
        }

        public DMLResponse(String id, String accountId, String name){
            this.id = id;
            this.name = name;
            this.accountId = accountId;
        }
    }
}