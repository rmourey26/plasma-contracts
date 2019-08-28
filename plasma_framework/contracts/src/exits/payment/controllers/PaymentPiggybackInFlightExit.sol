pragma solidity ^0.5.0;
pragma experimental ABIEncoderV2;

import "../PaymentExitDataModel.sol";
import "../PaymentInFlightExitModelLib.sol";
import "../routers/PaymentInFlightExitRouterArgs.sol";
import "../../models/OutputGuardModel.sol";
import "../../interfaces/IOutputGuardHandler.sol";
import "../../registries/OutputGuardHandlerRegistry.sol";
import "../../utils/ExitableTimestamp.sol";
import "../../utils/ExitId.sol";
import "../../utils/OutputGuard.sol";
import "../../../framework/PlasmaFramework.sol";
import "../../../framework/interfaces/IExitProcessor.sol";
import "../../../transactions/outputs/PaymentOutputModel.sol";
import "../../../transactions/PaymentTransactionModel.sol";
import "../../../utils/IsDeposit.sol";
import "../../../utils/UtxoPosLib.sol";

library PaymentPiggybackInFlightExit {
    using UtxoPosLib for UtxoPosLib.UtxoPos;
    using IsDeposit for IsDeposit.Predicate;
    using ExitableTimestamp for ExitableTimestamp.Calculator;
    using PaymentInFlightExitModelLib for PaymentExitDataModel.InFlightExit;
    using PaymentOutputModel for PaymentOutputModel.Output;

    uint8 constant public MAX_INPUT_NUM = 4;
    uint8 constant public MAX_OUTPUT_NUM = 4;

    struct Controller {
        PlasmaFramework framework;
        IsDeposit.Predicate isDeposit;
        ExitableTimestamp.Calculator exitableTimestampCalculator;
        IExitProcessor exitProcessor;
        OutputGuardHandlerRegistry outputGuardHandlerRegistry;
        uint256 minExitPeriod;
    }

    event InFlightExitPiggybacked(
        address indexed exitTarget,
        bytes32 txHash,
        bool isPiggybackInput,
        uint16 index
    );

    function buildController(
        PlasmaFramework framework,
        IExitProcessor exitProcessor,
        OutputGuardHandlerRegistry outputGuardHandlerRegistry
    )
        public
        view
        returns (Controller memory)
    {
        return Controller({
            framework: framework,
            isDeposit: IsDeposit.Predicate(framework.CHILD_BLOCK_INTERVAL()),
            exitableTimestampCalculator: ExitableTimestamp.Calculator(framework.minExitPeriod()),
            exitProcessor: exitProcessor,
            outputGuardHandlerRegistry: outputGuardHandlerRegistry,
            minExitPeriod: framework.minExitPeriod()
        });
    }

    function run(
        Controller memory self,
        PaymentExitDataModel.InFlightExitMap storage inFlightExitMap,
        PaymentInFlightExitRouterArgs.PiggybackInFlightExitArgs memory args
    )
        public
    {
        uint192 exitId = ExitId.getInFlightExitId(args.inFlightTx);
        PaymentExitDataModel.InFlightExit storage exit = inFlightExitMap.exits[exitId];

        require(exit.exitStartTimestamp != 0, "No in-flight exit to piggyback on");
        require(exit.isInFirstPhase(self.minExitPeriod), "Can only piggyback in first phase of exit period");

        uint256 indexMaxNum = args.isPiggybackInput? MAX_INPUT_NUM : MAX_OUTPUT_NUM;
        require(args.index < indexMaxNum, "Index exceed max size of the input or output");
        require(!exit.isPiggybacked(args.index, args.isPiggybackInput), "The indexed input/output has been piggybacked already");

        bytes32 outputGuard = args.isPiggybackInput?
            exit.outputGuardForInputs[args.index] : getOutputGuardFromPaymentTxBytes(args.inFlightTx, args.index);

        address payable exitTarget = getExitTargetOfOutput(self, outputGuard, args.outputType, args.outputGuardPreimage);
        require(exitTarget == msg.sender, "Can be called by the exit target only");

        PaymentExitDataModel.WithdrawData storage withdrawData = args.isPiggybackInput?
            exit.inputs[args.index] : exit.outputs[args.index];

        if (exit.isFirstPiggybackOfTheToken(withdrawData.token)) {
            enqueue(self, withdrawData.token, UtxoPosLib.UtxoPos(exit.position), exitId);
        }

        // Exit Target is set in piggyback instead of start in-flight exit due to the fact that potentially only
        // the owner has the data or output guard preimage
        withdrawData.exitTarget = exitTarget;
        exit.setPiggybacked(args.index, args.isPiggybackInput);

        emit InFlightExitPiggybacked(msg.sender, keccak256(args.inFlightTx), args.isPiggybackInput, args.index);
    }

    function enqueue(
        Controller memory controller,
        address token,
        UtxoPosLib.UtxoPos memory utxoPos,
        uint192 exitId
    )
        private
    {
        (, uint256 blockTimestamp) = controller.framework.blocks(utxoPos.blockNum());

        // TODO: change the ExitableTimestamp interface as 'isDeposit' should be used only in SE, in IFE it doesn't matter
        // Could update the interface to be cleaner and not forcing a "false" here.
        // https://github.com/omisego/plasma-contracts/issues/216
        bool isPositionDeposit = false;
        uint64 exitableAt = controller.exitableTimestampCalculator.calculate(now, blockTimestamp, isPositionDeposit);

        controller.framework.enqueue(token, exitableAt, utxoPos.txPos(), exitId, controller.exitProcessor);
    }

    function getOutputGuardFromPaymentTxBytes(bytes memory txBytes, uint16 outputIndex)
        private
        pure
        returns (bytes32)
    {
        PaymentOutputModel.Output memory output = PaymentTransactionModel.decode(txBytes).outputs[outputIndex];
        return output.outputGuard;
    }

    function getExitTargetOfOutput(
        Controller memory controller,
        bytes32 outputGuard,
        uint256 outputType,
        bytes memory outputGuardPreimage
    )
        private
        view
        returns (address payable)
    {
        OutputGuardModel.Data memory outputGuardData = OutputGuardModel.Data({
            guard: outputGuard,
            outputType: outputType,
            preimage: outputGuardPreimage
        });
        IOutputGuardHandler handler = controller.outputGuardHandlerRegistry
                                                .outputGuardHandlers(outputType);

        require(address(handler) != address(0),
            "Does not have outputGuardHandler registered for the output type");

        require(handler.isValid(outputGuardData),
                "Some of the output guard related information is not valid");
        return handler.getExitTarget(outputGuardData);
    }
}
