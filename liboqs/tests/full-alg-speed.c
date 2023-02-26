//Including the required dependencies 
#include <math.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <oqs/oqs.h>
#include <unistd.h>
#include "ds_benchmark.h"
#include "system_info.c"

//Checking to see if it has been specified that a pi is being used and whether the PMU has been activated
#if defined(OQS_USE_RASPBERRY_PI)
#define _OQS_RASPBERRY_PI
#endif
#if defined(OQS_SPEED_USE_ARM_PMU)
#define SPEED_USE_ARM_PMU
#endif

/*Function for performing the benchmarking KEM algorithms included in liboqs */
static OQS_STATUS kem_speed_wrapper(const char *method_name, uint64_t duration, bool printInfo) {

    //Setup
	OQS_KEM *kem = NULL;
	uint8_t *public_key = NULL;
	uint8_t *secret_key = NULL;
	uint8_t *ciphertext = NULL;
	uint8_t *shared_secret_e = NULL;
	uint8_t *shared_secret_d = NULL;
	OQS_STATUS ret = OQS_ERROR;
	kem = OQS_KEM_new(method_name);
	if (kem == NULL) {
		return OQS_SUCCESS;
	}

	//Allocating memory to the algorithm components
	public_key = malloc(kem->length_public_key);
	secret_key = malloc(kem->length_secret_key);
	ciphertext = malloc(kem->length_ciphertext);
	shared_secret_e = malloc(kem->length_shared_secret);
	shared_secret_d = malloc(kem->length_shared_secret);

	//Checking to see if memory allocation is sucsessful
	if ((public_key == NULL) || (secret_key == NULL) || (ciphertext == NULL) || (shared_secret_e == NULL) || (shared_secret_d == NULL)) {
		fprintf(stderr, "ERROR: malloc failed\n");
		goto err;
	}

	//Performing the algorithm operations and calculating the CPU metrics using the TIME_OPERATION_SECONDS macro
	printf("%-36s | %10s | %14s | %15s | %10s | %25s | %10s\n", kem->method_name, "", "", "", "", "", "");
	TIME_OPERATION_SECONDS(OQS_KEM_keypair(kem, public_key, secret_key), "keygen", duration)
	TIME_OPERATION_SECONDS(OQS_KEM_encaps(kem, ciphertext, shared_secret_e, public_key), "encaps", duration)
	TIME_OPERATION_SECONDS(OQS_KEM_decaps(kem, shared_secret_d, ciphertext, secret_key), "decaps", duration)


    //Printing the Algorithm Info
    if (printInfo) {
		printf("public key bytes: %zu, ciphertext bytes: %zu, secret key bytes: %zu, shared secret key bytes: %zu, NIST level: %d, IND-CCA: %s\n", kem->length_public_key, 
        kem->length_ciphertext, kem->length_secret_key, kem->length_shared_secret, kem->claimed_nist_level, kem->ind_cca ? "Y" : "N");
	}

	//Cleaing up after perfoming the operations 
	ret = OQS_SUCCESS;
	goto cleanup;

	err:
		ret = OQS_ERROR;

	cleanup:
		if (kem != NULL) {
			OQS_MEM_secure_free(secret_key, kem->length_secret_key);
			OQS_MEM_secure_free(shared_secret_e, kem->length_shared_secret);
			OQS_MEM_secure_free(shared_secret_d, kem->length_shared_secret);
		}
		OQS_MEM_insecure_free(public_key);
		OQS_MEM_insecure_free(ciphertext);
		OQS_KEM_free(kem);

		return ret;
}

/*Function for performing the benchmarking Digital Signature Algorithms included in liboqs */
static OQS_STATUS sig_speed_wrapper(const char *method_name, uint64_t duration, bool printInfo) {

    //Setup
 	OQS_SIG *sig = NULL;
 	uint8_t *public_key = NULL;
 	uint8_t *secret_key = NULL;
 	uint8_t *message = NULL;
 	uint8_t *signature = NULL;
 	size_t message_len = 50;
 	size_t signature_len = 0;
 	OQS_STATUS ret = OQS_ERROR;

 	sig = OQS_SIG_new(method_name);
 	if (sig == NULL) {
 		return OQS_SUCCESS;
 	}


    //Allocating the memory to the algorithm components
 	public_key = malloc(sig->length_public_key);
 	secret_key = malloc(sig->length_secret_key);
 	message = malloc(message_len);
 	signature = malloc(sig->length_signature);

    //Checking to see if memory allocation was sucssesful
 	if ((public_key == NULL) || (secret_key == NULL) || (message == NULL) || (signature == NULL)) {
 		fprintf(stderr, "ERROR: malloc failed\n");
 		goto err;
 	}

    //Performing the evaluation of the different stages of the digital signature
 	OQS_randombytes(message, message_len);

 	printf("%-36s | %10s | %14s | %15s | %10s | %25s | %10s\n", sig->method_name, "", "", "", "", "", "");
 	TIME_OPERATION_SECONDS(OQS_SIG_keypair(sig, public_key, secret_key), "keypair", duration)
 	TIME_OPERATION_SECONDS(OQS_SIG_sign(sig, signature, &signature_len, message, message_len, secret_key), "sign", duration)
 	TIME_OPERATION_SECONDS(OQS_SIG_verify(sig, message, message_len, signature, signature_len, public_key), "verify", duration)

    //Declaring Succsess and cleaning up
 	ret = OQS_SUCCESS;
 	goto cleanup;
     err:
         ret = OQS_ERROR;

     cleanup:
         if (sig != NULL) {
             OQS_MEM_secure_free(secret_key, sig->length_secret_key);
         }
         OQS_MEM_insecure_free(public_key);
         OQS_MEM_insecure_free(signature);
         OQS_MEM_insecure_free(message);
         OQS_SIG_free(sig);

 	return ret;
}
/*-------------------------------------------------------------------------------*/

/*Function for outputing a list of the algorithms if needed*/
int print_algs(void) {

    //removing files if they already exsist
    if(access("KEM-Algs.txt", F_OK) == 0) {
        remove("KEM-Algs.txt");
    }
    if(access("SIG-Algs.txt", F_OK) == 0) {
        remove("SIG-Algs.txt");
    }

    //printing out a list of the algorithms for KEM
    freopen("KEM-Algs.txt","w", stdout);
    printf("KEM Algorithms Available:\n");
    for (size_t alg_id_kem = 0; alg_id_kem < OQS_KEM_algs_length; alg_id_kem++) {
            printf("%s\n", OQS_KEM_alg_identifier(alg_id_kem));
    }
    fclose(stdout);
    fflush(stdout);    

    //Printing out a list of the algorithms Sig
    freopen("SIG-Algs.txt", "w", stdout);
    printf("Digital Signature Algorithms Available:\n");
    for (size_t alg_id_sig = 0; alg_id_sig < OQS_KEM_algs_length; alg_id_sig++) {
            printf("%s\n", OQS_SIG_alg_identifier(alg_id_sig));
    }
    fclose(stdout);
    fflush(stdout);

    return 0;
}
/*-------------------------------------------------------------------------------*/

/*The main fucntion of the testing code */
int main(int argc, char* argv[]) {
    int run_count = 0;

    //Setting 
	OQS_randombytes_switch_algorithm(OQS_RAND_alg_openssl);
	int ret = EXIT_SUCCESS;
	OQS_STATUS rc;
	uint64_t duration = 3;
	bool printKemInfo = false;
    bool printSigInfo = false;

    //Outputing algs list if needed
    if (argc > 1) {
        printf("%s\n", argv[1]);
        if (strcmp(argv[1], "--print-algs") == 0) {
            printf("works\n");
            print_algs();
        }
        else {
            printf("Incorrect arguemnt!! - only argument acceptable is --print-algs\n");
            exit(1);
        }
    }

    //Printing out system information and running test notice to terminal
    print_system_info();
    printf("\n************************************************\n");
    printf("Running KEM and Digital Signature CPU Speed Tests\n");
    printf("************************************************\n");

    /*Performing the Kem Algorithm Tests*/

    //Looping throuhg all the kem algorithms based on the specified number of runs
    for (int z = 0; z <= 14; z++) {

        //Operations loop
        char filename[100];
        sprintf(filename, "..%sresults%s%s%d.csv", PATH_SEPARATOR, PATH_SEPARATOR, "test-kem-speed-", z+1);
        freopen(filename, "w", stdout);
        
        PRINT_TIMER_HEADER

            for (size_t i = 0; i < OQS_KEM_algs_length; i++) {
                rc = kem_speed_wrapper(OQS_KEM_alg_identifier(i), duration, printKemInfo);
                if (rc != OQS_SUCCESS) {
                    // ret = EXIT_FAILURE;
                }
            }

        fclose(stdout);
        fflush(stdout);

    }
    /*---------------------------------------*/

    /*Performing the Digital Signature Tests*/
    //Looping throuhg all the sig algorithms based on the specified number of runs
    for (int y = 0; y <= 14; y++) {
    
        //Operations loop
        char filename[100];
        sprintf(filename, "..%sresults%s%s%d.csv", PATH_SEPARATOR, PATH_SEPARATOR, "test-sig-speed-", y+1);
        freopen(filename, "w", stdout);
        PRINT_TIMER_HEADER

            for (size_t i = 0; i < OQS_SIG_algs_length; i++) {
                //Doing CPU metric tests for SIG
                rc = sig_speed_wrapper(OQS_SIG_alg_identifier(i), duration, printSigInfo);

                if (rc != OQS_SUCCESS) {
                    // ret = EXIT_FAILURE;
                }
            }

        fclose(stdout);
        fflush(stdout);
        /*---------------------------------------*/
    }

    return 0;
}