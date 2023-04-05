@isTest
public with sharing class ModelsTest {
    @isTest
    public static void testCPQModels(){
        CPQ_Models.QuoteModel quote = new CPQ_Models.QuoteModel();
        quote.record = new SBQQ__Quote__c();
        quote.lineItems = new List<CPQ_Models.QuoteLineModel>();
        quote.lineItemGroups = new List<CPQ_Models.QuoteLineGroupModel>();
        quote.nextKey = 1;
        quote.applyAdditionalDiscountLast = false;
        quote.applyPartnerDiscountFirst = false;
        quote.channelDiscountsOffList = false;
        quote.customerTotal = 0;
        quote.netTotal = 0;
        quote.netNonSegmentTotal = 0;

        CPQ_Models.QuoteLineModel quoteLine = new CPQ_Models.QuoteLineModel();
        quoteLine.record = new SBQQ__QuoteLine__c();
        quoteLine.amountDiscountProrated = false;
        quoteLine.parentGroupKey = 1;
        quoteLine.parentItemKey = 2;
        quoteLine.key = 3;
        quoteLine.upliftable = false;
        quoteLine.configurationType = 'TEST';
        quoteLine.configurationEvent = 'TEST';
        quoteLine.reconfigurationDisabled = false;
        quoteLine.descriptionLocked = false;
        quoteLine.productQuantityEditable = false;
        quoteLine.productQuantityScale = 1;
        quoteLine.dimensionType = 'TEST';
        quoteLine.productHasDimensions = false;
        quoteLine.targetCustomerAmount = 0;
        quoteLine.targetCustomerTotal = 0;

        CPQ_Models.QuoteLineGroupModel quoteLineGroup = new CPQ_Models.QuoteLineGroupModel();
        quoteLineGroup.record = new SBQQ__QuoteLineGroup__c();
        quoteLineGroup.netNonSegmentTotal = 0;
        quoteLineGroup.key = 0;

        CPQ_Models.ProductModel product = new CPQ_Models.ProductModel();
        product.record = new Product2();
        product.upgradedAssetId = null;
        product.currencySymbol = 'USD';
        product.currencyCode = 'USD';
        product.featureCategories = new List<String>();
        product.options = new List<CPQ_Models.OptionModel>();
        product.features = new List<CPQ_Models.FeatureModel>();
        product.configuration = new CPQ_Models.ConfigurationModel();
        product.configurationAttributes = new List<CPQ_Models.ConfigAttributeModel>();
        product.inheritedConfigurationAttributes = new List<CPQ_Models.ConfigAttributeModel>();
        product.constraints = new List<CPQ_Models.ConstraintModel>();

        CPQ_Models.OptionModel option = new CPQ_Models.OptionModel();
        option.record = new SBQQ__ProductOption__c();
        option.externalConfigurationData = new Map<String, String>();
        option.configurable = false;
        option.configurationRequired = false;
        option.quantityEditable = false;
        option.priceEditable = false;
        option.productQuantityScale = 0;
        option.priorOptionExists = false;
        option.dependentIds = new Set<Id>();
        option.controllingGroups = new Map<String, Set<Id>>();
        option.exclusionGroups = new Map<String, Set<Id>>();
        option.reconfigureDimensionWarning = 'TEST';
        option.hasDimension = false;
        option.isUpgrade = false;
        option.dynamicOptionKey = 'TEST';

        CPQ_Models.FeatureModel feature = new CPQ_Models.FeatureModel();
        feature.record = new SBQQ__ProductFeature__c();
        feature.instructionsText = 'TEST';
        feature.containsUpgrades = false;

        CPQ_Models.ConfigurationModel configModel = new CPQ_Models.ConfigurationModel();
        configModel.configuredProductId = null;
        configModel.optionId = null;
        configModel.optionData = new SBQQ__ProductOption__c();
        configModel.configurationData = new SBQQ__ProductOption__c();
        configModel.inheritedConfigurationData = new SBQQ__ProductOption__c();
        configModel.optionConfigurations = new List<CPQ_Models.ConfigurationModel>();
        configModel.configured = false;
        configModel.configurationEntered = false;
        configModel.changedByProductActions = false;
        configModel.isDynamicOption = false;
        configModel.isUpgrade = false;
        configModel.disabledOptionIds = new Set<Id>();
        configModel.hiddenOptionIds = new Set<Id>();
        configModel.listPrice = 0;
        configModel.priceEditable = false;
        configModel.validationMessages = new List<String>();
        configModel.dynamicOptionKey = 'TEST';

        CPQ_Models.ConfigAttributeModel configAttModel = new CPQ_Models.ConfigAttributeModel();
        configAttModel.name = 'TEST';
        configAttModel.targetFieldName = 'TEST';
        configAttModel.displayOrder = 0;
        configAttModel.colmnOrder = 'TEST';
        configAttModel.required = false;
        configAttModel.featureId = null;
        configAttModel.position = 'TEST';
        configAttModel.appliedImmediately = false;
        configAttModel.applyToProductOptions = false;
        configAttModel.autoSelect = false;
        configAttModel.shownValues = new List<String>();
        configAttModel.hiddenValues = new List<String>();
        configAttModel.hidden = false;
        configAttModel.noSuchFieldName = 'TEST';
        configAttModel.myId = null;

        CPQ_Models.ConstraintModel constraint = new CPQ_Models.ConstraintModel();
        constraint.record = new SBQQ__OptionConstraint__c();
        constraint.priorOptionExists = false;
    }

    @isTest
    public static void testOrderFunnelModels(){
        OrderFunnel_Models.AccountModel accModel = new OrderFunnel_Models.AccountModel();
        accModel.id = '';
        accModel.name = '';
        accModel.phone = '';
        accModel.billingAddress = new OrderFunnel_Models.AddressModel();

        OrderFunnel_Models.ContactModel conModel = new OrderFunnel_Models.ContactModel();
        conModel.id = '';
        conModel.firstName = '';
        conModel.lastName = '';
        conModel.email = '';
        conModel.phone = '';
        conModel.accountId = '';
        conModel.mailingAddress = new OrderFunnel_Models.AddressModel();
        conModel.account = new OrderFunnel_Models.AccountModel();

        OrderFunnel_Models.AddressModel addModel = new OrderFunnel_Models.AddressModel();
        addModel.street = '';
        addModel.city = '';
        addModel.state = '';
        addModel.postalCode = '';
        addModel.country = '';
        addModel.latitude = 0;
        addModel.longitude = 0;

        OrderFunnel_Models.AssetModel assetModel = new OrderFunnel_Models.AssetModel();
        assetModel.name = '';
        assetModel.accountId = '';
        assetModel.sfId = '';
        assetModel.teId = '';
        assetModel.cuId = '';
        assetModel.currentTracingId = '';
        assetModel.address = new OrderFunnel_Models.AddressModel();
        assetModel.accessCode = '';
        assetModel.accessNote = '';


        OrderFunnel_Models.AdditionalFieldModel addFieldModel = new OrderFunnel_Models.AdditionalFieldModel('1','label','value');

        OrderFunnel_Models.MetricModel metricModel = new OrderFunnel_Models.MetricModel();
        OrderFunnel_Models.MetricModel metricModel2 = new OrderFunnel_Models.MetricModel('type','value');

        OrderFunnel_Models.ProductSearchResultModel searchModel = new OrderFunnel_Models.ProductSearchResultModel();
        searchModel.id = '';
        searchModel.externalId = '';
        searchModel.productName = '';
        searchModel.productCode = '';
        searchModel.displayName = '';
        searchModel.productPhotoURL = '';
        searchModel.type = '';
        searchModel.description = '';
        searchModel.family = '';
        searchModel.merchandisingTags = '';
        searchModel.clientProduct = false;

        OrderFunnel_Models.Product2Model productModel = new OrderFunnel_Models.Product2Model();
        productModel.id = '';
        productModel.externalId = '';
        productModel.productName = '';
        productModel.productCode = '';
        productModel.displayName = '';
        productModel.productPhotoURL = '';
        productModel.type = '';
        productModel.description = '';
        productModel.family = '';
        productModel.merchandisingTags = '';
        productModel.netsuiteItem = '';
        productModel.taxCode = '';

        OrderFunnel_Models.ServiceTypeModel serviceTypeModel = new OrderFunnel_Models.ServiceTypeModel();
        serviceTypeModel.id = '';
        serviceTypeModel.name = '';
        serviceTypeModel.serviceCode = '';

        OrderFunnel_Models.ServiceTypeDescription serviceTypeDescription = new OrderFunnel_Models.ServiceTypeDescription();
        serviceTypeDescription.contractor = '';
        serviceTypeDescription.customer = '';

        OrderFunnel_Models.PhotoSetModel photoSetModel = new OrderFunnel_Models.PhotoSetModel();
        photoSetModel.photoId = '';
        photoSetModel.photoName = '';
        photoSetModel.photoDefinitionId = '';
        photoSetModel.photoDescription = '';
        photoSetModel.photoExample = '';
        photoSetModel.photoInstruction = '';
        photoSetModel.timing = '';

        OrderFunnel_Models.OrderModel orderModel = new OrderFunnel_Models.OrderModel();
        orderModel.orderId = '';
        orderModel.orderNumber = '';
        orderModel.orderDate = '';
        orderModel.orderStatus = '';
        orderModel.planType = '';
        orderModel.billingType = '';
        orderModel.paymentFrequency = '';
        orderModel.orderStartDate = '';
        orderModel.orderEndDate = '';
        orderModel.earliestAvailableStartDate = '';
        orderModel.latestAvailableEndDate = '';
        orderModel.workOrderReference = '';
        orderModel.contractor = '';
        orderModel.workCrewId = '';
        orderModel.serviceId = '';
        orderModel.stripeTransactionId = '';
        orderModel.customer = new OrderFunnel_Models.AccountModel();
        orderModel.asset = new OrderFunnel_Models.AssetModel();

        OrderFunnel_Models.OrderItemModel orderItemModel = new OrderFunnel_Models.OrderItemModel();
        orderItemModel.id = '';
        orderItemModel.parentId = '';
        orderItemModel.product = new OrderFunnel_Models.Product2Model();

        OrderFunnel_Models.BundleModel bundleModel = new OrderFunnel_Models.BundleModel();
        bundleModel.recurrenceType = '';
        bundleModel.nteAmount = 0;

        OrderFunnel_Models.PackageModel packageModel = new OrderFunnel_Models.PackageModel();
        packageModel.additionalInstructions = '';
        packageModel.scheduleTemplate = '';
        packageModel.scheduleTemplateId = '';
        packageModel.billingSchedule = '';
        packageModel.customerPrice = 0;
        packageModel.contractorPayout = 0;
        packageModel.glInsuranceCost = 0;
        packageModel.oaInsuranceCost = 0;
        packageModel.estimatedEffort = 0;
        packageModel.estimatedTax = 0;
        packageModel.aspTotal= 0;
        OrderFunnel_Models.OptionalPackageModel optionalModel = new OrderFunnel_Models.OptionalPackageModel();

        OrderFunnel_Models.DMLResponse dmlResponse = new OrderFunnel_Models.DMLResponse('id');
        OrderFunnel_Models.DMLResponse dmlResponse2 = new OrderFunnel_Models.DMLResponse('id','accountId');
    }
}