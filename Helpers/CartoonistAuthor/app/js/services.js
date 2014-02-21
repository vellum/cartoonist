'use strict';

/* Services */

// ToDo: wire this up to a backend like firebase or parse

var cartoonistServices = angular.module('theApp.services', []);

// register service called DataProviderService
cartoonistServices.factory('DataProviderService', ['$rootScope', function($rootScope){

    var MODEL_KEY = 'model';
    //localStorage.clear();

    var service = {
        model: null,
        SaveState: function () {
            localStorage.setItem(MODEL_KEY, angular.toJson(service.model));
        },
        RestoreState: function () {
            var previousState = localStorage.getItem(MODEL_KEY);
            if (previousState!=null&&previousState!=undefined) {
                service.model = angular.fromJson(previousState);

                // make a dictionary lookup of models by id (for easy reference)
                parseAndIndex(service.model);

                // angular seems to be writing state variables into the tree model
                // so reset these little tags
                parseAndClean(service.model, function(model){
                    model.shouldShowEditButton = false;
                    model.shouldShowEditPanel = false;
                    model.shouldShowExtendedOptions = false;
                    model.shouldShowJointButtons = false;
                    model.shouldShowSequenceButtons = false;
                    model.shouldShowAddButtons = false;
                });
            } else {
                service.model = {"type":"sequence","nodes":[{"type":"frame","celltype":"nocaption","image":"panel-01","caption":"","id":"SLWWMWFNFPS2PJBSJKW2GGOXF6ROU8SC","parentid":"IM93P09D5EHDIUOOA0LMKBYSV9XO36HE"},{"type":"frame","celltype":"caption","image":"panel-02","caption":"My morning ritual.","id":"R18P2RE6CWBTD2T2M6JXJGGE4W3JPTW7","parentid":"IM93P09D5EHDIUOOA0LMKBYSV9XO36HE"},{"type":"frame","celltype":"caption","image":"panel-03","caption":"One ceramic mug, heated.","id":"UWYA2D017KWOF0118PAS8F9X48O8MDSI","parentid":"IM93P09D5EHDIUOOA0LMKBYSV9XO36HE"},{"type":"frame","celltype":"caption","image":"panel-05","caption":"One ceramic coffee dripper.","id":"EH2SGSXP2OQNBPQPDX5EI1OQDRSINR04","parentid":"IM93P09D5EHDIUOOA0LMKBYSV9XO36HE"},{"type":"frame","celltype":"caption","image":"panel-06","caption":"One paper filter.","id":"ABAFECGB3ACW8KAUO973EBG4BVEGAPX5","parentid":"IM93P09D5EHDIUOOA0LMKBYSV9XO36HE"},{"type":"frame","celltype":"caption","image":"panel-07","caption":"One zeroed tare.","id":"HNI0BMI7KDJ0Q58DPTM38OK78XFK0NPY","parentid":"IM93P09D5EHDIUOOA0LMKBYSV9XO36HE"},{"type":"frame","celltype":"caption","image":"panel-08","caption":"Hand-ground beans.","id":"LB25KMNWTXVXPAKI9U84HR5VKBPIV6JX","parentid":"IM93P09D5EHDIUOOA0LMKBYSV9XO36HE"},{"type":"frame","celltype":"caption","image":"panel-09","caption":"About 21 grams' worth.","id":"IKRUQV8A3RKFHXXV7MU0BG5FW9B0032W","parentid":"IM93P09D5EHDIUOOA0LMKBYSV9XO36HE"},{"type":"frame","celltype":"caption","image":"panel-10","caption":"One drip kettle, hot.","id":"H91JUYD2KG3D12TAC1IYB237LSHVV0L9","parentid":"IM93P09D5EHDIUOOA0LMKBYSV9XO36HE"},{"type":"frame","celltype":"caption","image":"panel-11","caption":"A first pour.","id":"CX5A4VGKJGM8BOBX8D8UUEHQVRRA26QH","parentid":"IM93P09D5EHDIUOOA0LMKBYSV9XO36HE"},{"type":"frame","celltype":"caption","image":"panel-12","caption":"A modest wait.","id":"Q4YIVI68KOID3BUJG14TOLNX5PIOCQG4","parentid":"IM93P09D5EHDIUOOA0LMKBYSV9XO36HE"},{"type":"frame","celltype":"caption","image":"panel-13","caption":"A deep breath or two.","id":"GI437GHG3T84LA0WNFI7HBIFPBJTTNDN","parentid":"IM93P09D5EHDIUOOA0LMKBYSV9XO36HE"},{"type":"frame","celltype":"caption","image":"panel-14","caption":"Another pour.","id":"BAMR0PB9PLF19D5IMIAY4NXHVNWFRG9A","parentid":"IM93P09D5EHDIUOOA0LMKBYSV9XO36HE"},{"type":"frame","celltype":"caption","image":"panel-15","caption":"The water recedes. The mind wanders.","id":"M2YKWDMXXHCKOT9O9JKMW73USW14SCLR","parentid":"IM93P09D5EHDIUOOA0LMKBYSV9XO36HE"},{"type":"frame","celltype":"caption","image":"panel-16","caption":"Another deep breath or two.","id":"K94TRFCPW8XNNBSQHIDER0AYOMMU9NUM","parentid":"IM93P09D5EHDIUOOA0LMKBYSV9XO36HE"},{"type":"frame","celltype":"caption","image":"panel-17","caption":"One heroic optimism about this outcome.","id":"GRGUKIURGQCFIBMWD0R1UV00TNXFMX77","parentid":"IM93P09D5EHDIUOOA0LMKBYSV9XO36HE"},{"type":"frame","celltype":"caption","image":"panel-18","caption":"Hands are fallible. Mistakes and happy accidents abound. ","id":"FE53MXLYL75MCYV7XDDYYM2P6VW7HSV2","parentid":"IM93P09D5EHDIUOOA0LMKBYSV9XO36HE"},{"type":"frame","celltype":"caption","image":"panel-19","caption":"It's this push and pull that keeps me doing this.","id":"O9NPADMYWBA4EAJQ1C5ES839X69GK4G8","parentid":"IM93P09D5EHDIUOOA0LMKBYSV9XO36HE"},{"type":"frame","celltype":"caption","image":"panel-20","caption":"We make making a ritual, and we call it craft.","id":"VP43EKIE5THY585830PER783KE53X81I","parentid":"IM93P09D5EHDIUOOA0LMKBYSV9XO36HE"},{"type":"frame","celltype":"caption","image":"panel-21","caption":"Here, people care about craft. We practice it.","id":"I3EAW7XHKWAQIJP9IDM6BPVJHHV9DS0N","parentid":"IM93P09D5EHDIUOOA0LMKBYSV9XO36HE"},{"type":"frame","celltype":"caption","image":"panel-22","caption":"We nerd out on tiny details.","id":"OSE8XUPL69U2R38F8PPPW2HW4P7D0N33","parentid":"IM93P09D5EHDIUOOA0LMKBYSV9XO36HE"},{"type":"frame","celltype":"caption","image":"panel-23","caption":"I used to work in studios set up like factories. ","id":"JPTP6DXROWLR8PXUASMA028LLO67CPB5","parentid":"IM93P09D5EHDIUOOA0LMKBYSV9XO36HE"},{"type":"frame","celltype":"caption","image":"panel-24","caption":"The quantity-over-quality thing was soul crushing. It's better here.","id":"F5T0DSF7G1CA3HDB9VYKKK786MISC4S4","parentid":"IM93P09D5EHDIUOOA0LMKBYSV9XO36HE"},{"type":"frame","celltype":"caption","image":"panel-25","caption":"We're watching a live stream of our fearless leader. He's on a panel discussion at a conference.","id":"RKSL9T3MGYDHFUV8CI78TDEEBQJMYYW9","parentid":"IM93P09D5EHDIUOOA0LMKBYSV9XO36HE"},{"type":"frame","celltype":"nocaption","image":"panel-26","caption":"","id":"E4AX75J7HEP2VH9BRGV0TNTBS586O45G","parentid":"IM93P09D5EHDIUOOA0LMKBYSV9XO36HE"},{"type":"frame","celltype":"nocaption","image":"panel-27","caption":"","id":"H1W2M2L9EHPHV8D6UWK8FOH0FXJO3TEV","parentid":"IM93P09D5EHDIUOOA0LMKBYSV9XO36HE"},{"type":"frame","celltype":"caption","image":"panel-28","caption":"A meeting. My phone tells me to leave now, but -- honestly, I'd love to just drink this coffee.","id":"X36FRMRRVHWA7A3F9630DDIYC1EIRGXG","parentid":"IM93P09D5EHDIUOOA0LMKBYSV9XO36HE"},{"type":"joint","selected":"0","children":[{"type":"sequence","nodes":[{"type":"frame","celltype":"wireframe","image":null,"caption":"empty_0 / f0","id":"DRQQD5BACJCHDG9QSHUN5RPV1U5QJRUB","parentid":"FF7BF40U9HIYSNUTGV0S728W4ANM1LRP"},{"type":"frame","celltype":"wireframe","image":null,"caption":"empty_0 / f1","id":"BHPDCU755AVLVIFSQG7YTAYM5VV2HX6D","parentid":"FF7BF40U9HIYSNUTGV0S728W4ANM1LRP"}],"image":"panel-29","caption":"Leave now","id":"KPGY2TOEGF2H3S1QMEDAA9EJ6F63TSHL","parentid":"RDJY6IF353LN1RKDC33KTKSBXSBCP07C","celltype":"caption"},{"type":"sequence","nodes":[{"type":"frame","celltype":"wireframe","image":null,"caption":"empty_1 / f0","id":"U3RSVJEURPH5V115AATNSM2XYKFSACI1","parentid":"S2TJLE9MYT6NYVP2CELF4FT3BA7QCQUD"},{"type":"frame","celltype":"wireframe","image":null,"caption":"empty_1 / f1","id":"SCM2U78GFL4280S6B3L0GCPR5FPN7E14","parentid":"S2TJLE9MYT6NYVP2CELF4FT3BA7QCQUD"}],"image":"panel-30","caption":"Stay a while","id":"D4PA8X3N9Q9RKBKTN9LB2HSUARLC6I4Y","parentid":"RDJY6IF353LN1RKDC33KTKSBXSBCP07C","celltype":"caption"}],"id":"WT3G7DCXVIVV3NSYJ0KJ5ADDY8OHIL05","parentid":"IM93P09D5EHDIUOOA0LMKBYSV9XO36HE"}],"image":null,"caption":"r","id":"IM93P09D5EHDIUOOA0LMKBYSV9XO36HE"};//makeSampleTree();
            }
        }
    };
    service.RestoreState();
    return service;
}]);
