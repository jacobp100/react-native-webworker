// import './ensure-react-native-is-initialized';
// import NativeModules from 'react-native/Libraries/BatchedBridge/NativeModules';
// import NativeEventEmitter from 'react-native/Libraries/EventEmitter/NativeEventEmitter';
import { NativeModules, NativeEventEmitter } from 'react-native';

// @ts-expect-error
const isTurboModuleEnabled = global.__turboModuleProxy != null;

const SelfModule = isTurboModuleEnabled
  ? require('./specs/SelfModule').default
  : NativeModules.SelfModule;
const ThreadSelfManagerEvents = new NativeEventEmitter(SelfModule);

export type Self = {
  postMessage: (message: string) => void;
  onmessage: ((event: { data: string }) => void) | undefined;
};

const self: Self = {
  postMessage(message: string) {
    if (message != null) {
      SelfModule.postMessage(message);
    }
  },
  onmessage: undefined,
};

ThreadSelfManagerEvents.addListener('message', (message: string) => {
  if (typeof self.onmessage === 'function') {
    try {
      self.onmessage({ data: message });
    } catch (e: any) {
      SelfModule.postError(e.message ?? 'Unknown error');
    }
  }
});

export default self;
