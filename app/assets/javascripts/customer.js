//= require  dirPagination
var customerApp = angular.module("customerApp", ['angularUtils.directives.dirPagination'])

customerApp.controller("customerController", ['$scope', '$http',  '$timeout', function ($scope, $http, $timeout) {
	
	vm = $scope
	vm.init = init
	vm.shouldShowPage = shouldShowPage
	vm.showCustomerDetail = showCustomerDetail
	vm.backToCustomerList = backToCustomerList
	vm.is_active = is_active
	vm.setActiveTab = setActiveTab
	vm.isVerticalTabActive = isVerticalTabActive
	vm.setVerticalTabActive = setVerticalTabActive
	vm.getCustomers = getCustomers
	vm.listPerPage = 10;

	vm.customerHeaders = ["^", "COMPANY NAME", "MAIN CONTACT", "PHONE", "COUNTRY/CITY", "REGION", "SEND FILES", "SCHEDULED VISITS", "R2P STATUS", "SERIAL NUMBER", "PRODUCT NUMBER"]
	vm.init()
	vm.customerCompanyName = "Company Name" 
	vm.mainContactName = "John Doe"
	vm.emailAddress = "johndoename@business.com"
	vm.customerSiteAddress = "Avda. Barcelona, 229, Nave 1,2,3, 08750"
	vm.customerSiteCountry = "Switzerland"
	vm.mainContactPhoneNumber = "+34666666666"
	vm.printerModel = "Lorem ipsum dolor sit amed"
	vm.printerSerialNumber = "SG78534002"
	vm.serialNumber = "SG7853400s6521634792"
	vm.blocks = ["Expert Now(Default)", "What's AOT", "Learn with HP(Default)", "Maintenance(Default)", "Job Packing(Default)", "Printheads", "Design optimization", "Design optimization", "Part Defects", "How to use Magics/Netfabb with MJF", "Cost per part", 	"Lean Working Environment", "Share Tips & Tricks Document", "Share X Material Whitepaper"]

	
	function init() {
		vm.customers = []
		vm.activePage = "customerList"
		vm.getCustomers()
	}

	function getCustomers(argument) {
		vm.showLoaderIndicator = true
		$http
		.get('/get_customers')
		.success(function(response){
			vm.customers = response.customers
			vm.showLoaderIndicator = false
		})
		.error(function(error){
			vm.customers = []
			vm.showLoaderIndicator = false
		})
	}

	function shouldShowPage(in_page) {
		return (vm.activePage == in_page)
	}

	function  backToCustomerList() {
		vm.activePage = "customerList"
	}

	function showCustomerDetail(customer) {
		vm.selectedCustomer = customer
		vm.customerCompanyName = vm.selectedCustomer.customer_name
		vm.printerSerialNumber = vm.selectedCustomer.serial_number
		vm.activePage = "customerDetails"
		vm.activeTab = "Customer profile"
		vm.activeVerticalTab = "Customer main info"
	}

	function is_active(tab_name) {
		return (vm.activeTab == tab_name ? "active" : "")
	}

	function isVerticalTabActive(vertical_tab_name) {
		return (vm.activeVerticalTab == vertical_tab_name ? "active" : "")
	}

	function setActiveTab(tab_name, vertical_tab_name) {
		vm.activeTab = tab_name
		vm.activeVerticalTab = vertical_tab_name
	}

	function setVerticalTabActive(vertical_tab_name) {
		vm.activeVerticalTab = vertical_tab_name
	}

}])