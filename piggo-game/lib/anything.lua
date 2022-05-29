-- // BaseApp reflects the ABCI application implementation.
local BaseApp = {
    new = function() return {
        -- // cms =  sdk.CommitMultiStore // Main (uncached) state
        -- // queryRouter =  sdk.QueryRouter = // router for redirecting query calls
        -- // initChainer = sdk.InitChainer = // initialize state with validators and state blob
        -- // beginBlocker =  sdk.BeginBlocker // logic to run before any txs
        -- // endBlocker =  sdk.EndBlocker =  // logic to run after all txs, and to determine valset changes
        -- // addrPeerFilter sdk.PeerFilter =  // filter peers by address and port
        -- // idPeerFilter =  sdk.PeerFilter =  // filter peers by node ID
        -- // interBlockCache sdk.MultiStorePersistentCache
        -- // minGasPrices sdk.DecCoins
        sdk = function() end,
        CommitMultiStore = function() end,
        QueryRouter = function() end,
        InitChainer = function() end,
        BeginBlocker = function() end,
        EndBlocker = function(self) return self end,
        PeerFilter = function() end,
        MultiStorePersistentCache = function() end,
        DecCoins = function() end,
    }
    end,
}

return BaseApp
	

-- 	// name = string =  // application name from abci.Info
-- 	// db = dbm.DB =  // common DB backend,
-- 	// txHandler = tx.Handler =  // txHandler for {Deliver,Check}Tx and simulations
	
-- 	// storeLoader =  StoreLoader = // function to handle store loading, may be overridden with SetStoreLoader()
-- 	// grpcQueryRouter =  *GRPCQueryRouter =  // router for redirecting gRPC query calls
-- 	// interfaceRegistry types.InterfaceRegistry

	
	
	
	
	
	
-- 	fauxMerkleMode bool =  // if true, IAVL MountStores uses MountStoresDB for simulation speed.

-- 	// manages snapshots, i.e. dumps of app state at certain intervals
-- 	snapshotManager = *snapshots.Manager
-- 	snapshotInterval =  uint64 // block interval between state sync snapshots
-- 	snapshotKeepRecent uint32 // recent state sync snapshots to keep

-- 	// volatile states:
-- 	//
-- 	// checkState is set on InitChain and reset on Commit
-- 	// deliverState is set on InitChain and BeginBlock and set to nil on Commit
-- 	checkState =  *state // for CheckTx
-- 	deliverState *state // for DeliverTx

-- 	// an inter-block write-through cache provided to the context during deliverState
	

-- 	// absent validators from begin block
-- 	voteInfos []abci.VoteInfo

-- 	// paramStore is used to query for ABCI consensus parameters from an
-- 	// application parameter store.
-- 	paramStore ParamStore

-- 	// The minimum gas prices a validator is willing to accept for processing a
-- 	// transaction. This is mainly used for DoS and spam prevention.
	

-- 	// initialHeight is the initial height at which we start the baseapp
-- 	initialHeight int64

-- 	// flag for sealing options and parameters to a BaseApp
-- 	sealed bool

-- 	// block height at which to halt the chain and gracefully shutdown
-- 	haltHeight uint64

-- 	// minimum block time (in Unix seconds) at which to halt the chain and gracefully shutdown
-- 	haltTime uint64

-- 	// minRetainBlocks defines the minimum block height offset from the current
-- 	// block being committed, such that all blocks past this offset are pruned
-- 	// from Tendermint. It is used as part of the process of determining the
-- 	// ResponseCommit.RetainHeight value during ABCI Commit. A value of 0 indicates
-- 	// that no blocks should be pruned.
-- 	//
-- 	// Note: Tendermint block pruning is dependant on this parameter in conunction
-- 	// with the unbonding (safety threshold) period, state pruning and state sync
-- 	// snapshot parameters to determine the correct minimum value of
-- 	// ResponseCommit.RetainHeight.
-- 	minRetainBlocks uint64

-- 	// application's version string
-- 	version string

-- 	// application's protocol version that increments on every upgrade
-- 	// if BaseApp is passed to the upgrade keeper's NewKeeper method.
-- 	appVersion uint64

-- 	// trace set will return full stack traces for errors in ABCI Log field
-- 	trace bool

-- 	// indexEvents defines the set of events in the form {eventType}.{attributeKey},
-- 	// which informs Tendermint what to index. If empty, all events will be indexed.
-- 	indexEvents map[string]struct{}

-- 	// abciListeners for hooking into the ABCI message processing of the BaseApp
-- 	// and exposing the requests and responses to external consumers
-- 	abciListeners []ABCIListener
-- }




